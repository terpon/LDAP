"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPSession',
	#superclass : 'Model',
	#instVars : [
		'server',
		'connected',
		'roots'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPSession >> connected [

	^ connected
]

{ #category : 'accessing' }
LDAPSession >> connected: aBoolean [

	connected := aBoolean
]

{ #category : 'instance creation' }
LDAPSession >> connectionClass [ 

	^  self isSSL ifTrue: [ LDAPSConnection ]  ifFalse: [ LDAPConnection ]
]

{ #category : 'accessing - defaults' }
LDAPSession >> defaultPort [

	^ self isSSL ifTrue: [ 636 ] ifFalse: [ 389 ]
]

{ #category : 'initialization' }
LDAPSession >> initialize [ 

	super initialize.
	server := LDAPServerInfo new.
	self reset
]

{ #category : 'initialization' }
LDAPSession >> reset [
"Initialize"
	connected := false.
	roots := #().

]

{ #category : 'accessing' }
LDAPSession >> roots [
	^ roots
]

{ #category : 'accessing' }
LDAPSession >> roots: anObject [

	roots := anObject.
	self valueChanged 
]

{ #category : 'accessing' }
LDAPSession >> server [

	^ server
]

{ #category : 'accessing' }
LDAPSession >> server: anObject [

	server := anObject
]
