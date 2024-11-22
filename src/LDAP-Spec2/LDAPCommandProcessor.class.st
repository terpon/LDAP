"
I run the result of LDAP commands asynchronously
"
Class {
	#name : 'LDAPCommandProcessor',
	#superclass : 'LDAPAsyncTask',
	#instVars : [
		'request',
		'command',
		'result'
	],
	#category : 'LDAP-Spec2-Connection',
	#package : 'LDAP-Spec2',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPCommandProcessor >> command [

	^ command
]

{ #category : 'errors' }
LDAPCommandProcessor >> nilCommand [

	command := nil.
	result := LDAPResult newCode: 80 name: '' message: 'nil LDAPCommand returned'.

	
]

{ #category : 'executing' }
LDAPCommandProcessor >> processCommand: aCommand [
	"Process command in a fork to avoid blocking the request queue"

	[ 
		aCommand ifNil: [ self nilCommand. ^ self failure ].
		
		command := aCommand.
		result := command responses last.
		command success ifTrue: [ self success ] ifFalse: [ self failure ]
	] fork
]

{ #category : 'accessing' }
LDAPCommandProcessor >> request [

	^ request 
]

{ #category : 'accessing' }
LDAPCommandProcessor >> request: anObject [
	
	request := anObject 
]

{ #category : 'accessing' }
LDAPCommandProcessor >> result [

	^ result
]
