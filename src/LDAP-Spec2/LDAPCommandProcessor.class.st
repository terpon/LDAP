"
I run the result of LDAP commands asynchronously
"
Class {
	#name : 'LDAPCommandProcessor',
	#superclass : 'Object',
	#instVars : [
		'request',
		'block'
	],
	#category : 'LDAP-Spec2-Connection',
	#package : 'LDAP-Spec2',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPCommandProcessor >> onResponseDo: aBlock [

	block := aBlock 
]

{ #category : 'executing' }
LDAPCommandProcessor >> processCommand: aCommand [
"Process command in a fork to avoid blocking the request queue"
	[ block cull: aCommand ] fork
]

{ #category : 'accessing' }
LDAPCommandProcessor >> request [

	^ request 
]

{ #category : 'accessing' }
LDAPCommandProcessor >> request: anObject [
	
	request := anObject 
]
