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
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
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

	request := anObject.
]

{ #category : 'private - dispatching' }
LDAPRequestTask >> sendRequestTo: aConnection [
"This can be run in a forked process"

	command := [ aConnection request: self request ] 
		on: Exception do: [ :ex | error := ex. ex pass. nil ].
		
	self waitForCompletion
]

{ #category : 'running' }
LDAPRequestTask >> startOn: aConnection [

	^ [ self sendRequestTo: aConnection ] forkAt: LDAPBrowser requestPriority named: 'LDAP task for ', self request className

]

{ #category : 'running' }
LDAPRequestTask >> succeed [

	successAction ifNotNil: [ :action | action cull: command ]
]

{ #category : 'private - running' }
LDAPRequestTask >> waitForCompletion [

	command ifNil: [ 
		error ifNil: [ error := LDAPNoConnectionException new ].
		^self fail 
	].

	[ command wait ] on: LDAPTimeOut do: [ :ex | 
		error := ex. 
		^self fail 
	].

	"Should be catched by LDAPTimeOut"
	command isDone ifFalse: [ 
		error := LDAPException new. 
		^self fail 
	].
	
	command success ifTrue: [ ^ self succeed ].

	self fail.
]

{ #category : 'running' }
LDAPRequestTask >> waitOn: aConnection [

	self sendRequestTo: aConnection
]
