"
I represent the network connection of a client to a LDAP server.
"
Class {
	#name : 'LDAPConnection',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'host',
		'port',
		'worker',
		'connectRequest'
	],
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'accessing - defaults' }
LDAPConnection class >> defaultPort [

	^ 389
]

{ #category : 'documentation' }
LDAPConnection class >> missingRFC2251 [
	self notYetImplemented
	
"The following parts of RFC 2251 have not been implemented:

SOON 
- When Message ID is over the maximum, we should rebind to reset the counter. Although practically it would be enough to just zero the counter when it overflows, since we can reuse the IDs when we have alroady gotten a response
- When rebinding we must terminate all pending operations, as the server will get rid of them; note we will have to notify waiters.
- Distinction between binary attributes (as is <AttributeType>:binary -- do we really need something implemented?
- UTF-8 encoding
- Extended Request
EVENTUALLY
- Controls / Search constraints
- Automatic referral following
- SearchResultReference (Continuation References)
- Filter extensibleMatch and MatchingRuleAssertion
- Would be nice to have a getSchema (by using subschemaSubentry)
WONT
- SASL Bind
"
]

{ #category : 'instance creation' }
LDAPConnection class >> socketClass [
	^ SocketStream
]

{ #category : 'instance creation' }
LDAPConnection class >> to: aHostname [
	^ self to: aHostname port: 389
]

{ #category : 'instance creation' }
LDAPConnection class >> to: aHostname port: aPort [
	| obj |
	obj := self new host: aHostname; port: aPort.
	obj connect.
	^ obj
]

{ #category : 'command execution' }
LDAPConnection >> abandon: aCommand [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	(worker isCommandPending: aCommand) ifFalse: [ ^ self ].

	worker abandon: aCommand.
	^ self request: (LDAPAbandonRequest newId: aCommand message id).

]

{ #category : 'accessing' }
LDAPConnection >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'connecting' }
LDAPConnection >> asyncConnect [

	worker := LDAPWorker new connection: self. 
	^ worker start.
]

{ #category : 'connecting' }
LDAPConnection >> connect [

	| aProcess |
	aProcess := self asyncConnect.
	worker waitUntilConnected.
	^ aProcess
]

{ #category : 'connecting' }
LDAPConnection >> disconnect [

	| unbind |
	worker ifNil: [ ^self ].
	worker isRunning ifFalse: [ ^self ].

	unbind := self request: LDAPUnbindRequest new.
	unbind ifNotNil: [ :command | command wait ].
	worker stop.
	worker := nil.
]

{ #category : 'accessing' }
LDAPConnection >> host [

	^ host
]

{ #category : 'accessing' }
LDAPConnection >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
LDAPConnection >> initializeSocket [

	| sockStream |
	sockStream := self class socketClass openConnectionToHostNamed: self host port: self port.
	sockStream 
		binary;
		shouldSignal: true;
		timeout: 60;
		autoFlush: false.
		
	^ sockStream
]

{ #category : 'testing' }
LDAPConnection >> isConnected [

	^ worker isNotNil and: [ worker isConnected ]
]

{ #category : 'testing' }
LDAPConnection >> isSSL [
	^ false
]

{ #category : 'callbacks' }
LDAPConnection >> onClosedSocket: anException [

	self announcer announce: (LDAPIsDisconnected new cause: anException).

]

{ #category : 'callbacks' }
LDAPConnection >> onNewSocket [
	
	| aCommand |
	connectRequest ifNil: [ ^self ].
	self isConnected ifFalse: [ ^self ].
	
	connectRequest ifNil: [ ^self announcer announce: LDAPIsConnected new ].
	
	aCommand := self request: connectRequest.
	aCommand ifNil: [ ^self ].
	[ self waitOnConnect: aCommand ] fork
]

{ #category : 'accessing' }
LDAPConnection >> port [

	((port isNil) or: [ port isZero ]) ifTrue: [ ^ self class defaultPort ].
	^  port
]

{ #category : 'accessing' }
LDAPConnection >> port: anObject [

	port := anObject
]

{ #category : 'copying' }
LDAPConnection >> postCopy [ 

	super postCopy.
	
	"Copy start as disconnected, remove reference to original worker"
	worker := nil.
]

{ #category : 'command execution' }
LDAPConnection >> request: aRequest [
	| command message |
	self isConnected ifFalse: [ ^ nil ].
	
	message := LDAPMessage new operation: aRequest.
	command := LDAPCommand new initializeWith: message.

	worker send: command.
	^ command
]

{ #category : 'enumerating' }
LDAPConnection >> requestOnConnect: aRequest [
"Request to send on socket reconnection. Usually a bind request to authenticate the connection"

	connectRequest := aRequest.
]

{ #category : 'callbacks' }
LDAPConnection >> waitOnConnect: aCommand [
	
	| ex |
	aCommand wait.
	
	"Timeout on connectRequest"
	aCommand isDone ifFalse: [ ^self disconnect ].
	
	aCommand success ifTrue: [ ^self announcer announce: LDAPIsConnected new ].

	"Trap exception, disconnect then announce exception"
	ex := [ aCommand signalExceptions ] on: Exception do: [ :result | result ].
	self disconnect.
	self announcer announce: (LDAPIsDisconnected new cause: ex)
]
