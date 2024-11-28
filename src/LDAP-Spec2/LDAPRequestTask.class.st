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

{ #category : 'activation' }
LDAPRequestTask >> activate [
	
	command ifNotNil: [ 
		command success ifTrue: [ ^ successAction ifNotNil: [ :action | action cull: command ] ] 
	].

	failureAction ifNotNil: [ :action | action cull: command cull: error ].
]

{ #category : 'accessing' }
LDAPRequestTask >> command [

	^ command
]

{ #category : 'activation' }
LDAPRequestTask >> onFailureDo: aBlock [

	failureAction := aBlock
]

{ #category : 'activation' }
LDAPRequestTask >> onSuccessDo: aBlock [

	successAction := aBlock
]

{ #category : 'private - running' }
LDAPRequestTask >> processCommand [

	"Check for potential errors before and after the wait on connection."
	"Don’t do the activation now, the request queue must have a chance to
	send a disconnected announcement"
	command ifNil: [ error := LDAPNoConnectionException new signal. ^ self ].
	
	[ command wait ] on: Exception do: [ :ex | error := ex. ex pass. ^ self ].

	command responses ifEmpty: [ error := LDAPNoConnectionException new signal. ^ self ].

	error := nil.
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
LDAPRequestTask >> waitFor: aCommand [
	
	command := aCommand.
	self processCommand.
]
