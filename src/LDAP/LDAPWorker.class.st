"
A worker (thread)
"
Class {
	#name : 'LDAPWorker',
	#superclass : 'Object',
	#instVars : [
		'sockStream',
		'hostname',
		'port',
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
LDAPWorker class >> newTo: aHostname port: aPort [
	^ self new initialize: aHostname port: aPort
]

{ #category : 'instance creation' }
LDAPWorker class >> socketClass [
	^ SocketStream
]

{ #category : 'dispatching' }
LDAPWorker >> abandon: aMessage [
	self removeTargetId: aMessage id.
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

{ #category : 'connecting' }
LDAPWorker >> connect [
	[ sockStream := self class socketClass openConnectionToHostNamed: hostname port: port ]
		on: Exception do: [:ex | sockStream := nil.  ex pass ].

	sockStream ifNil: [ ^ self ].
	
	sockStream 
		binary;
		autoFlush: false;
		timeout: 30.
		
	self postConnect.

]

{ #category : 'connecting' }
LDAPWorker >> disconnect [
	self stop.
	sockStream close.
	sockStream  := nil.
	
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
LDAPWorker >> initialize: aHostname port: aPort [
	hostname := aHostname.
	port := aPort.
	nextMessageId := 0.
	lock := Semaphore forMutualExclusion.
	"looks like if we use the WVD here we wont see exceptions thrown.. hrmmm"
	"targets := WeakValueDictionary new."
	targets := Dictionary new.
	running := false.
]

{ #category : 'accessing' }
LDAPWorker >> isConnected [
	 sockStream ifNil: [ ^ true ].	
	^ sockStream isConnected
]

{ #category : 'accessing' }
LDAPWorker >> isRunning [
	^ self isConnected and: running
]

{ #category : 'private - dispatching' }
LDAPWorker >> nextMessageId [
	"here we should check wether we're past the message id limit, and if so reconnect and bind"
	nextMessageId := nextMessageId + 1.
	^ nextMessageId
]

{ #category : 'connecting' }
LDAPWorker >> postConnect [ 
"Nothing in base class"
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

{ #category : 'running' }
LDAPWorker >> start [
	| process |
	self isConnected ifFalse: [ ^ nil ].
	running := true.
	process := [ 
		[running] whileTrue: [
			|  element  |
			element := [LDAPMessage newFrom: sockStream] on: Error do:[:ex| 
				Transcript cr; show: ex description.
				running := false.
				"ex pass."
			].
			"Transcript show: '********* READ ONE OF:  ', element asString; cr."
			running ifTrue:[self dispatchMessage: element].
		]
	] fork.
	^ process
]

{ #category : 'running' }
LDAPWorker >> stop [
	running := false.
]
