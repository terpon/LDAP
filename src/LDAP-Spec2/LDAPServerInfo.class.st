"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPServerInfo',
	#superclass : 'Model',
	#instVars : [
		'username',
		'password',
		'hostname',
		'port',
		'ssl'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'comparing' }
LDAPServerInfo >> = anObject [

	(self hostname = anObject hostname) ifFalse:  [ ^ false ].
	(self port = anObject port) ifFalse:  [ ^ false ].
	(self isSSL = anObject isSSL) ifFalse:  [ ^ false ].
	(self username = anObject username) ifFalse:  [ ^ false ].
	(self password = anObject password) ifFalse:  [ ^ false ].

	^ true
]

{ #category : 'instance creation' }
LDAPServerInfo >> bindRequest [ 

	^ 	LDAPBindRequest new username: username; password: password.

]

{ #category : 'instance creation' }
LDAPServerInfo >> connection [

	| newConnection |
	newConnection := self connectionClass new.
	newConnection host: hostname.
	newConnection port: port.
	^ newConnection
]

{ #category : 'instance creation' }
LDAPServerInfo >> connectionClass [ 

	^  self isSSL ifTrue: [ LDAPSConnection ]  ifFalse: [ LDAPConnection ]
]

{ #category : 'accessing - defaults' }
LDAPServerInfo >> defaultPort [

	^ self isSSL ifTrue: [ 636 ] ifFalse: [ 389 ]
]

{ #category : 'comparing' }
LDAPServerInfo >> hash [

	| hash |
	hash := self hostname hash.
	hash := hash bitXor: self port hash.
	hash := hash bitXor: self username.
	hash := hash bitXor: self password.
	self isSSL ifTrue:  [ hash := hash bitInvert ].
	^ hash
]

{ #category : 'accessing' }
LDAPServerInfo >> hostname [

	^ hostname
]

{ #category : 'accessing' }
LDAPServerInfo >> hostname: aString [

	hostname := aString
]

{ #category : 'initialization' }
LDAPServerInfo >> initialize [ 

	super initialize.
	
	hostname := ''.
	ssl := false.
	port := self defaultPort.
	username := ''.
	password := ''.
]

{ #category : 'testing' }
LDAPServerInfo >> isSSL [
	^ ssl
]

{ #category : 'accessing' }
LDAPServerInfo >> password [

	^ password
]

{ #category : 'accessing' }
LDAPServerInfo >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
LDAPServerInfo >> port [

	^ port
]

{ #category : 'accessing' }
LDAPServerInfo >> port: aNumber [

	port := aNumber
]

{ #category : 'accessing' }
LDAPServerInfo >> ssl: aBoolean [

	ssl := aBoolean
]

{ #category : 'accessing' }
LDAPServerInfo >> username [

	^ username
]

{ #category : 'accessing' }
LDAPServerInfo >> username: anObject [

	username := anObject
]
