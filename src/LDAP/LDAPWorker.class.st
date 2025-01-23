"
I am a worker thread that listen to the LDAP responses.

I defer to my owner `LDAPConnection` for the creation of the socket but I own the `SocketStream`, and I also send the requests.

I maintain a dictionary of requests sent.
"
Class {
	#name : 'LDAPWorker',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'sockStream',
		'nextMessageId',
		'lock',
		'targets',
		'running',
		'exception',
		'connected',
		'listenProcess'
	],
	#category : 'LDAP-Internal',
	#package : 'LDAP',
	#tag : 'Internal'
}

{ #category : 'dispatching' }
LDAPWorker >> abandon: aCommand [
	| id |
	id := aCommand message id.
	self removeTargetId: id.
]

{ #category : 'private - dispatching' }
LDAPWorker >> addTarget: aCommand [
	| messageId |
	messageId := self nextMessageId.
	lock critical: [
		targets at: messageId 
			ifPresent: [ Error signal: 'messageId already present -- shouldn’t happen' ]
			ifAbsentPut: aCommand
	].
	^  messageId 

]

{ #category : 'error handling' }
LDAPWorker >> announceTargetsLost [
"The connection is lost. If request are pending, notify them"

	| result name commands |
	name := exception ifNotNil: [ exception description ] ifNil: [ 'Connection lost' ]. 
	result := LDAPResult newCode: 80 name: name message: 'Connection to server lost. No response from request.'.
	commands := #().
	lock critical: [
		commands := targets values.
		targets removeAll.
	].
	commands do: [ :command | command processResponse: result ].

]

{ #category : 'accessing' }
LDAPWorker >> connection: anObject [

	connection := anObject
]

{ #category : 'private - dispatching' }
LDAPWorker >> dispatchMessage: aMessage [
	| command id |
	aMessage ifNil: [ ^self ].
	id := aMessage id.

	"this is an unsolicited notification -- as it is advisory, we can ignore it for now"
	id = 0 ifTrue: [ ^ self ].

	"RFC says we MUST be prepared to receive replies to aborted requests -- so we eat it silently"
	command :=targets at: id
		ifAbsent: [ ^ self ].
	
	command ifNil: [ self removeTargetId: id. ^ self ].
	
	"extended results need some kind of handling -- RFC2251 says they are the result of a message with a control,
	which we don't have implemented, so there's no real need yet"
	command  processResponse: aMessage response.
	
	command wantsMoreResponses
		ifFalse: [ self removeTargetId: id ]


]

{ #category : 'initialization' }
LDAPWorker >> initialize [
	super initialize.
	
	nextMessageId := 0.
	lock := Semaphore forMutualExclusion.
	connected := Semaphore new.
	targets := WeakValueDictionary new.
	running := false.
]

{ #category : 'private - running' }
LDAPWorker >> initializeSocket [

	| newSocket |
	exception := nil.
	newSocket := [ connection initializeSocket ] on: NetworkError do: [ :ex | exception := ex. nil ].
	lock critical: [ sockStream := newSocket ].
	newSocket ifNil: [ ^ self releaseSocket ]. "Will call signalAll"

	connected signalAll.
	connection onNewSocket.
]

{ #category : 'dispatching' }
LDAPWorker >> isCommandPending: aCommand [
	| messageId |
	messageId := aCommand message id.
	^ lock critical: [ targets includesKey: messageId ]
]

{ #category : 'testing' }
LDAPWorker >> isConnected [

	^ lock critical: [ sockStream ifNil: [ false ] ifNotNil: [ :s | s isConnected ] ]
]

{ #category : 'testing' }
LDAPWorker >> isRunning [

	^ self isConnected and: running
]

{ #category : 'request handling' }
LDAPWorker >> listenLoop [
	"We create a listening Socket, then wait for a connection.
	After each connection we also check that the listening Socket is still valid"
	[ [running] whileTrue: [
		| looping |
		looping := true.
		self initializeSocket.
		sockStream ifNil: [ running := false. ^ self ].
		[looping] whileTrue: [
			sockStream isConnected 
				ifFalse: [ looping := false ]
				ifTrue: [ self readMessage ].
			running ifFalse: [ looping := false ].
		].
		self releaseSocket
	] 
	] ensure: [ self releaseSocket ].

]

{ #category : 'private - dispatching' }
LDAPWorker >> nextMessageId [
	"here we should check wether we're past the message id limit, and if so reconnect and bind"
	nextMessageId := nextMessageId + 1.
	^ nextMessageId
]

{ #category : 'private - running' }
LDAPWorker >> readMessage [
	[ [ [ 
		|  message  |
		self waitForData.
		message := LDAPDecoder from: sockStream.
		"Transcript show: '********* READ ONE OF:  ', message asString; cr."
		self dispatchMessage: message.
		
	] on: ConnectionTimedOut, ConnectionClosed do:[ :ex| 
				"wait for another loop if `running` is still true"
				^ self.
		].
	] on: NetworkError, SocketError do:[ :ex| 
				"send disconnect announcement, try to reconnect on next loop"
				Transcript cr; show: ex description; cr.
				^ self.
		].
	] on: Exception do: [ :ex |
			"Probably cannot recover"
			Transcript cr; show: ex description; cr.
			running := false.
			ex pass.
	].
]

{ #category : 'private - running' }
LDAPWorker >> releaseSocket [

	self announceTargetsLost.

	lock critical: [
		sockStream ifNotNil: [ :s | s close ].
		sockStream := nil.
	].

	connected signalAll.
	connection onClosedSocket: exception
]

{ #category : 'private - dispatching' }
LDAPWorker >> removeTargetId: aMessageId [
	lock critical: [
		targets removeKey: aMessageId ifAbsent: [ "we’re good" ]
	]
]

{ #category : 'dispatching' }
LDAPWorker >> send: aCommand [
	| message messageId |
	messageId := self addTarget: aCommand.
	message := aCommand message.
	message id: messageId.
	lock critical: [
		sockStream 
			nextPutAll: message encoded;
			flush.
	]
]

{ #category : 'running' }
LDAPWorker >> start [

	connected consumeAllSignals.

	listenProcess := [self listenLoop] newProcess.
	listenProcess name: ('LDAP listener on: {1}:{2}' format: { connection host . connection port }).
	listenProcess priority: Processor highIOPriority.

	running := true.
	listenProcess resume.
	^ listenProcess
]

{ #category : 'running' }
LDAPWorker >> stop [

	listenProcess ifNil: [ ^ self ].

	"This will call releaseSocket and call onClosedSocket"
	running := false.
	listenProcess isTerminating ifFalse: [ listenProcess terminate ].
	listenProcess := nil.

]

{ #category : 'private - running' }
LDAPWorker >> waitForData [

	"Check buffered stream first"
	sockStream isDataAvailable ifTrue: [ ^self ].
	sockStream socket ifNil: [ ^self ] ifNotNil: [ :s | s waitForDataFor: 5 ].
]

{ #category : 'running' }
LDAPWorker >> waitUntilConnected [

	"Wait on semaphore signaled on socket opened or closed"
	connected wait.

]
