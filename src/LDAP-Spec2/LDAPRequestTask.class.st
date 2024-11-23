Class {
	#name : 'LDAPRequestTask',
	#superclass : 'Object',
	#instVars : [
		'activationAction',
		'request',
		'command',
		'activateOnFailure'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'activation' }
LDAPRequestTask >> activate [

	activationAction cull: command
]

{ #category : 'accessing' }
LDAPRequestTask >> activateOnFailure [

	^ activateOnFailure
]

{ #category : 'accessing' }
LDAPRequestTask >> activateOnFailure: aBoolean [

	activateOnFailure := aBoolean
]

{ #category : 'accessing' }
LDAPRequestTask >> command [

	^ command
]

{ #category : 'accessing' }
LDAPRequestTask >> command: anObject [

	command := anObject
]

{ #category : 'initialization' }
LDAPRequestTask >> initialize [ 

	super initialize.
	activateOnFailure := false.
	activationAction := [ self error: 'no completion block' ].
]

{ #category : 'activation' }
LDAPRequestTask >> onResponseDo: aBlock [

	activationAction := aBlock
]

{ #category : 'accessing' }
LDAPRequestTask >> request [

	^ request
]

{ #category : 'accessing' }
LDAPRequestTask >> request: anObject [

	request := anObject
]
