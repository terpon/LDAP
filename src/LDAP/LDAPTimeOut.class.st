"
Error thrown when a LDAPCommand is not yet done after a wait call.
"
Class {
	#name : 'LDAPTimeOut',
	#superclass : 'Error',
	#instVars : [
		'command'
	],
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPTimeOut >> command [

	^ command
]

{ #category : 'accessing' }
LDAPTimeOut >> command: anObject [

	command := anObject
]
