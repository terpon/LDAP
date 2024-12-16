"
A worker (thread)
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
		'exception'
	],
	#category : 'LDAP-Internal',
	#package : 'LDAP',
	#tag : 'Internal'
}

{ #category : 'instance creation' }
LDAPWorker class >> socketClass [
	^ SocketStream
]

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
	name := exception ifNotNil: [ exception className ] ifNil: [ 'Connection lost' ]. 
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
	"looks like if we use the WVD here we wont see exceptions thrown.. hrmmm"
	"targets := WeakValueDictionary new."
	targets := Dictionary new.
	running := false.
]

{ #category : 'running' }
LDAPWorker >> initializeSocket [

	exception := nil.
	lock critical: [
		sockStream := [ self class socketClass openConnectionToHostNamed: connection host port: connection port ]
			on: NetworkError do: [ :ex | exception := ex. nil ].
		sockStream ifNil: [ ^ self ].
		sockStream 
			binary;
			shouldSignal: true;
			timeout: 60;
			autoFlush: false.
		self postConnect.
	].

	connection onNewSocket.
]

{ #category : 'dispatching' }
LDAPWorker >> isCommandPending: aCommand [
	| messageId |
	messageId := aCommand message id.
	lock critical: [
		targets at: messageId ifPresent: [ ^ true ]
	].
	^  false 

]

{ #category : 'testing' }
LDAPWorker >> isConnected [
	 sockStream ifNil: [ ^ false ].	
	^ sockStream isConnected
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
LDAPWorker >> postConnect [ 
"Nothing in base class"
]

{ #category : 'private - running' }
LDAPWorker >> readMessage [
	[ [ [ 
		|  message  |
		self waitForData.
		message := LDAPDecoder from: sockStream.
		"Transcript show: '********* READ ONE OF:  ', message asString; cr."
		self dispatchMessage: message.
		
	] on: ConnectionTimedOut do:[ :ex| 
				"wait for another loop"
				^ self.
		].
	] on: NetworkError do:[ :ex| 
				"Transcript cr; show: ex description; cr."
				"send disconnect announcement"
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

	connection onClosedSocket: exception
]

{ #category : 'private - dispatching' }
LDAPWorker >> removeTargetId: aMessageId [
	lock critical: [
		targets removeKey: aMessageId ifAbsent: [ "we ’re good" ]
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

{ #category : 'private - running' }
LDAPWorker >> start [
	| process |
	process := [self listenLoop] newProcess.
	process name: ('LDAP listener on: {1}:{2}' format: { connection host . connection port }).
	process priority: Processor highIOPriority.

	running := true.
	process resume.
	
	"Wait a bit so that the thread has a chance to connect"
	(Delay forMilliseconds: 10) wait.

	^ process
]

{ #category : 'private - running' }
LDAPWorker >> stop [
	running := false.
	self releaseSocket.
]

{ #category : 'private - running' }
LDAPWorker >> waitForData [

	"Check buffered stream first"
	sockStream isDataAvailable ifTrue: [ ^ self ].

	sockStream socket ifNil: [ ^ self ] ifNotNil: [ :s | s waitForDataFor: 5 ].

]
