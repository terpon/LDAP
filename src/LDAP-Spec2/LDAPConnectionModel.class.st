"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPConnectionModel',
	#superclass : 'Model',
	#instVars : [
		'username',
		'password',
		'server',
		'connected'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'running' }
LDAPConnectionModel >> bindRequest [ 

	^ 	LDAPBindRequest new username: username; password: password.

]

{ #category : 'accessing' }
LDAPConnectionModel >> connected [

	^ connected
]

{ #category : 'accessing' }
LDAPConnectionModel >> connected: anObject [

	connected := anObject
]

{ #category : 'accessing - defaults' }
LDAPConnectionModel >> defaultPort [

	^ server defaultPort
]

{ #category : 'accessing' }
LDAPConnectionModel >> hostname [

	^ server host ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPConnectionModel >> hostname: anObject [

	server host: anObject
]

{ #category : 'initialization' }
LDAPConnectionModel >> initialize [ 

	super initialize.
	
	server := LDAPConnection new.
	username := ''.
	password := ''.
	
	connected := false.
]

{ #category : 'testing' }
LDAPConnectionModel >> isSSL [
	^ server isSSL
]

{ #category : 'accessing' }
LDAPConnectionModel >> password [

	^ password
]

{ #category : 'accessing' }
LDAPConnectionModel >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
LDAPConnectionModel >> port [

	^ server port
]

{ #category : 'accessing' }
LDAPConnectionModel >> port: anObject [

	server port: anObject
]

{ #category : 'copying' }
LDAPConnectionModel >> postCopy [ 

	super postCopy.
	"We want a different stopped server we can modify"
	server := server copy.
]

{ #category : 'running' }
LDAPConnectionModel >> reconnect [
"Try to connect"
	connected := false.
	server isValid 
		ifTrue: [ server unbind ]
		ifFalse: [ server connect ].

]

{ #category : 'accessing' }
LDAPConnectionModel >> server [

	^ server
]

{ #category : 'accessing' }
LDAPConnectionModel >> server: anObject [

	server := anObject
]

{ #category : 'accessing' }
LDAPConnectionModel >> ssl: aBoolean [

	| newConnection |
	(aBoolean = server isSSL) ifTrue: [ ^ self ].

	newConnection := aBoolean ifTrue: [ LDAPSConnection new ]  ifFalse: [ LDAPConnection new ].
	newConnection host: server host.
	(server port = server defaultPort) ifFalse: [ newConnection port: server port ].
	self server: newConnection
]

{ #category : 'accessing' }
LDAPConnectionModel >> username [

	^ username
]

{ #category : 'accessing' }
LDAPConnectionModel >> username: anObject [

	username := anObject
]
