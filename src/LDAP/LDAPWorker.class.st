"
A worker (thread)
"
Class {
	#name : 'LDAPWorker',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'sockStream',
		'nextMessageId',
		'lock',
		'targets',
		'running'
	],
	#category : 'LDAP-Core',
	#package : 'LDAP',
	#tag : 'Core'
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

{ #category : 'running' }
LDAPWorker >> connectTo: aHostname port: aPort [
	host := aHostname.
	port := aPort.
	^ self start

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
LDAPWorker >> initializeServerSocket [

	lock critical: [
	
	sockStream := [ self class socketClass openConnectionToHostNamed: host port: port ]
		ifCurtailed: [ sockStream := nil. ].

	sockStream ifNil: [ ^ self ].
	sockStream 
		binary;
		shouldSignal: true;
		timeout: 60;
		autoFlush: false.
		
	self postConnect.
	]


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
		self initializeServerSocket.
		[looping] whileTrue: [
			sockStream isConnected 
				ifFalse: [ looping := false ]
				ifTrue: [ self readMessage ].
			running ifFalse: [ looping := false ].
		].
		self releaseServerSocket
	] 
	] ensure: [ self releaseServerSocket ].

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
	[ 
		|  message  |
		message := [ LDAPDecoder from: sockStream ] 
			on: ConnectionClosed,ConnectionTimedOut do:[ :ex| 
				Transcript cr; show: ex description; cr.
				"reconnect"
				^ self.
			]. 
		"Transcript show: '********* READ ONE OF:  ', message asString; cr."
		self dispatchMessage: message.
	] on: Exception do: [ :ex |
		"Cannot recover"
		Transcript cr; show: ex description; cr.
		running := false.
		ex pass.
	].


]

{ #category : 'private - running' }
LDAPWorker >> releaseServerSocket [
	sockStream ifNil: [ ^ self ].
	
	lock critical: [
		sockStream close.
		sockStream := nil.
	]	
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
	process priority: Processor highIOPriority.

	running := true.
	process resume.
	^ process
]

{ #category : 'private - running' }
LDAPWorker >> stop [
	running := false.
]
