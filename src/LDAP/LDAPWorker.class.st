"
A worker (thread)
"
Class {
	#name : 'LDAPWorker',
	#superclass : 'Object',
	#instVars : [
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
	[ 
		sockStream := self class socketClass openConnectionToHostNamed: aHostname port: aPort.
	]
	on: Exception do: [:ex | sockStream := nil.  ex pass ].

	sockStream ifNil: [ ^ self ].
	sockStream 
		binary;
		shouldSignal: true;
		timeout: 0;
		autoFlush: false.
		
	self postConnect.
	^ self start

]

{ #category : 'running' }
LDAPWorker >> disconnect [
	self stop.
	sockStream close.
	sockStream := nil.
	
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
	 sockStream ifNil: [ ^ true ].	
	^ sockStream isConnected
]

{ #category : 'testing' }
LDAPWorker >> isRunning [
	^ self isConnected and: running
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
	|  message  |
	message := [ LDAPDecoder from: sockStream ] 
		on: ConnectionClosed do:[ :ex| 
				Transcript cr; show: ex description.
				running := false.
				"ex pass."
		].
	^ message
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
	self isConnected ifFalse: [ ^ nil ].
	running := true.
	process := [
		[running] whileTrue: [
			|  message  |
			message := self readMessage.
			"Transcript show: '********* READ ONE OF:  ', message asString; cr."
			running ifTrue: [self dispatchMessage: message].
		]
	] fork.
	^ process
]

{ #category : 'private - running' }
LDAPWorker >> stop [
	running := false.
]
