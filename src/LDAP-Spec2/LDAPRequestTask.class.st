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

{ #category : 'running' }
LDAPRequestTask >> succeed [

	successAction ifNotNil: [ :action | action cull: command ]
]

{ #category : 'running' }
LDAPRequestTask >> waitFor: aCommand [

	command := aCommand.
	[ command wait ] on: LDAPTimeOut do: [ :ex | error := ex. ^ self fail ].

	command success ifTrue: [ ^ self succeed ].

	self fail.
]
