"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPSession',
	#superclass : 'Model',
	#instVars : [
		'username',
		'password',
		'server',
		'connected',
		'queue',
		'roots',
		'application'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPSession >> application [

	^ application
]

{ #category : 'accessing' }
LDAPSession >> application: anObject [

	application := anObject
]

{ #category : 'accessing' }
LDAPSession >> beSSL: aBoolean [

	| newConnection |
	(aBoolean = server isSSL) ifTrue: [ ^ self ].

	newConnection := aBoolean ifTrue: [ LDAPSConnection new ]  ifFalse: [ LDAPConnection new ].
	newConnection host: server host.
	(server port = server defaultPort) ifFalse: [ newConnection port: server port ].
	self disconnect.
	server := newConnection
]

{ #category : 'running' }
LDAPSession >> bindRequest [ 

	^ 	LDAPBindRequest new username: username; password: password.

]

{ #category : 'circuit setup' }
LDAPSession >> connect [
	| request |
	server isValid ifTrue: [ server unbind ] ifFalse: [ server connect ].
	
	request := self bindRequest.
	queue nextPut: request onResponseDo: [ :command | self onConnect: command ]
]

{ #category : 'accessing' }
LDAPSession >> connected [

	^ connected
]

{ #category : 'copying' }
LDAPSession >> copyFrom: aSessionOrPresenter [
"Return true if we should reconnect"
	| request newConnection |
	(self isSameConnection: aSessionOrPresenter) ifTrue: [ ^ false ].
	
	self disconnect.
	newConnection := (self isSSL = aSessionOrPresenter isSSL) 
		ifTrue: [ server ]
		ifFalse: [ aSessionOrPresenter isSSL ifTrue: [ LDAPSConnection new ]  ifFalse: [ LDAPConnection new ] ].

	newConnection host: aSessionOrPresenter hostname.
	newConnection port: aSessionOrPresenter port.
	server := newConnection.

	username := aSessionOrPresenter username.
	password := aSessionOrPresenter password.
	
	queue connection: server.
	^ true
]

{ #category : 'accessing - defaults' }
LDAPSession >> defaultPort [

	^ server defaultPort
]

{ #category : 'running' }
LDAPSession >> disconnect [

	server disconnect.
	queue stop; flush.
	connected := false.

]

{ #category : 'accessing' }
LDAPSession >> hostname [

	^ server host ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPSession >> hostname: anObject [

	server host: anObject
]

{ #category : 'initialization' }
LDAPSession >> initialize [ 

	super initialize.
	
	server := LDAPConnection new.
	username := ''.
	password := ''.
	
	self reset
]

{ #category : 'testing' }
LDAPSession >> isSSL [
	^ server isSSL
]

{ #category : 'testing' }
LDAPSession >> isSameConnection: anObject [
	
	(self hostname = anObject hostname) ifFalse:  [ ^ false ].
	(self port = anObject port) ifFalse:  [ ^ false ].
	(self isSSL = anObject isSSL) ifFalse:  [ ^ false ].
	(self username = anObject username) ifFalse:  [ ^ false ].
	(self password = anObject password) ifFalse:  [ ^ false ].

	"Other properties can be different"
	^ true
]

{ #category : 'callbacks' }
LDAPSession >> onConnect: aCommand [
	| success |
	success := application checkAndReport: aCommand.
	connected := success.
	success ifFalse: [ ^ self ].

	self sendNamingContextsSearch.
]

{ #category : 'callbacks' }
LDAPSession >> onNamingContexts: aCommand [
	| success searchResult |
	success := application checkAndReport: aCommand.
	
	roots := success
		ifFalse: [ #() ]
		ifTrue: [  
			searchResult := aCommand responses first.
			searchResult asDictionary at: 'namingContexts' ifAbsent: [ #() ] 
		].

	application openBrowser
]

{ #category : 'accessing' }
LDAPSession >> password [

	^ password
]

{ #category : 'accessing' }
LDAPSession >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
LDAPSession >> port [

	^ server port
]

{ #category : 'accessing' }
LDAPSession >> port: anObject [

	server port: anObject
]

{ #category : 'running' }
LDAPSession >> reset [
"Initialize"
	connected := false.
	queue := LDAPRequestQueue new.
	roots := #().

]

{ #category : 'accessing' }
LDAPSession >> roots [
	^ roots
]

{ #category : 'requests' }
LDAPSession >> sendNamingContextsSearch [

	| search |
	search := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
	queue nextPut: search onResponseDo: [ :command | self onNamingContexts: command ]
]

{ #category : 'accessing' }
LDAPSession >> server [

	^ server
]

{ #category : 'accessing' }
LDAPSession >> username [

	^ username
]

{ #category : 'accessing' }
LDAPSession >> username: anObject [

	username := anObject
]
