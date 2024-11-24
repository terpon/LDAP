"
A LDAPConnection describes the connection of a client to a LDAP server.
"
Class {
	#name : 'LDAPConnection',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'worker',
		'workerThread'
	],
	#category : 'LDAP-Core',
	#package : 'LDAP',
	#tag : 'Core'
}

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

{ #category : 'accessing' }
LDAPConnection class >> workerClass [
	^ LDAPWorker
]

{ #category : 'command execution' }
LDAPConnection >> abandon: aCommand [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	(worker isCommandPending: aCommand) ifFalse: [ ^ self ].

	worker abandon: aCommand.
	^ self request: (LDAPAbandonRequest newId: aCommand message id).

]

{ #category : 'running' }
LDAPConnection >> connect [

	worker := self class workerClass new.
	workerThread := worker connectTo: host port: self port.
]

{ #category : 'accessing - defaults' }
LDAPConnection >> defaultPort [

	^ 389
]

{ #category : 'connecting' }
LDAPConnection >> disconnect [

	workerThread ifNil: [ ^ self ].
	worker isRunning ifTrue: [ self unbind ].

	worker stop.
	"workerThread terminate. should be taken care by the stop"
	
	worker := nil.
	workerThread := nil.
]

{ #category : 'accessing' }
LDAPConnection >> host [

	^ host
]

{ #category : 'accessing' }
LDAPConnection >> host: anObject [

	host := anObject
]

{ #category : 'testing' }
LDAPConnection >> isConnected [
	^ self isValid and: [ worker isConnected ]
]

{ #category : 'testing' }
LDAPConnection >> isSSL [
	^ false
]

{ #category : 'testing' }
LDAPConnection >> isValid [
	"Answers whether the connection looks still valid"
	^ worker ifNotNil: [ :w | w isRunning ] ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPConnection >> port [

	^ ((port isNil) or: [ port isZero ]) ifTrue: [ self defaultPort ] ifFalse: [ port ]
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
	workerThread := nil.
]

{ #category : 'command execution' }
LDAPConnection >> request: aRequest [
	| command message |
	self isConnected ifFalse: [ LDAPNoConnectionException signal. ^ nil ].
	
	message := LDAPMessage new operation: aRequest.
	command := LDAPCommand new initializeWith: message.

	worker send: command.
	^ command
]

{ #category : 'binding' }
LDAPConnection >> unbind [
	^ self request: (LDAPUnbindRequest new)
]
