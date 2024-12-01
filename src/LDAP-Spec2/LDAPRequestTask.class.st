"
I wrap all information for asynchronous request handling.
"
Class {
	#name : 'LDAPRequestTask',
	#superclass : 'Object',
	#instVars : [
		'request',
		'successAction',
		'failureAction',
		'command',
		'error'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPRequestTask >> command [

	^ command
]

{ #category : 'running' }
LDAPRequestTask >> fail [

	failureAction ifNotNil: [ :action | action cull: command cull: error ].
]

{ #category : 'activation' }
LDAPRequestTask >> onFailureDo: aBlock [

	failureAction := aBlock
]

{ #category : 'activation' }
LDAPRequestTask >> onSuccessDo: aBlock [

	successAction := aBlock
]

{ #category : 'accessing' }
LDAPRequestTask >> request [

	^ request
]

{ #category : 'accessing' }
LDAPRequestTask >> request: anObject [

	request := anObject
]

{ #category : 'private - dispatching' }
LDAPRequestTask >> sendRequestTo: aConnection [
"This is run in a forked process"
	| aCommand |
	aCommand := [ aConnection request: self request ] on: Exception do: [ :ex | ex pass. nil ].
	aCommand ifNil: [ ^ nil ].
	self waitFor: aCommand.
]

{ #category : 'running' }
LDAPRequestTask >> startOn: anApplication [

	| aConnection |
	anApplication isConnected ifFalse: [ ^self fail ].
	
	aConnection := anApplication connection.
	^ [ self sendRequestTo: aConnection ] forkAt: Processor userBackgroundPriority named: 'LDAP task for ', self request className

]

{ #category : 'running' }
LDAPRequestTask >> succeed [

	successAction ifNotNil: [ :action | action cull: command ]
]

{ #category : 'private - running' }
LDAPRequestTask >> waitFor: aCommand [

	command := aCommand.
	[ command wait ] on: LDAPTimeOut do: [ :ex | error := ex. ^ self fail ].

	command success ifTrue: [ ^ self succeed ].

	self fail.
]
