"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPServerInformation',
	#superclass : 'Object',
	#instVars : [
		'username',
		'password',
		'hostname',
		'port',
		'rootDN',
		'method'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'comparing' }
LDAPServerInformation >> = anObject [

	(self hostname = anObject hostname) ifFalse:  [ ^ false ].
	(self method = anObject method) ifFalse:  [ ^ false ].
	(self port = anObject port) ifFalse:  [ (self isPortDefault = anObject isPortDefault) ifFalse: [^false] ].
	(self username = anObject username) ifFalse:  [ ^ false ].
	(self password = anObject password) ifFalse:  [ ^ false ].
	(self root = anObject root) ifFalse:  [ ^ false ].

	^ true
]

{ #category : 'converting' }
LDAPServerInformation >> asZnUrl [

	| url |
	url := ZnUrl new scheme: self scheme; host: self hostname.
	self isPortDefault ifFalse: [ url port: self port ].
	self root ifNotEmpty: [ :path | url addPathSegment: path ].
	^ url
]

{ #category : 'instance creation' }
LDAPServerInformation >> connectionClass [ 

	^  method connectionClass
]

{ #category : 'accessing - defaults' }
LDAPServerInformation >> defaultPort [

	^ method defaultPort
]

{ #category : 'testing' }
LDAPServerInformation >> hasUserCredentials [

	^ username isNotEmpty and: [ password isNotEmpty ]
]

{ #category : 'comparing' }
LDAPServerInformation >> hash [

	| hash |
	hash := hostname hash.
	hash := hash bitXor: port hash.
	hash := hash bitXor: username hash.
	hash := hash bitXor: password hash.
	hash := hash bitXor: method hash.
	^ hash
]

{ #category : 'accessing' }
LDAPServerInformation >> hostname [

	^ hostname
]

{ #category : 'accessing' }
LDAPServerInformation >> hostname: aString [

	hostname := aString
]

{ #category : 'initialization' }
LDAPServerInformation >> initialize [ 

	super initialize.
	
	hostname := ''.
	method := LDAPConnectionTCP new.
	port := 0.
	username := ''.
	password := ''.
	rootDN := ''.
]

{ #category : 'testing' }
LDAPServerInformation >> isPortDefault [
	^ port isZero or: [ port = self defaultPort ]
]

{ #category : 'accessing' }
LDAPServerInformation >> method [

	^ method
]

{ #category : 'accessing' }
LDAPServerInformation >> method: anObject [

	method := anObject
]

{ #category : 'instance creation' }
LDAPServerInformation >> newBindRequest [ 

	^ 	LDAPBindRequest new username: username; password: password.

]

{ #category : 'instance creation' }
LDAPServerInformation >> newConnection [

	| newConnection |
	newConnection := self connectionClass new.
	newConnection host: self hostname.
	newConnection port: self port.
	^ newConnection
]

{ #category : 'accessing' }
LDAPServerInformation >> password [

	^ password
]

{ #category : 'accessing' }
LDAPServerInformation >> password: anObject [

	password := anObject
]

{ #category : 'accessing' }
LDAPServerInformation >> port [

	^ port
]

{ #category : 'accessing' }
LDAPServerInformation >> port: aNumber [

	port := aNumber
]

{ #category : 'accessing' }
LDAPServerInformation >> root [

	^ rootDN
]

{ #category : 'accessing' }
LDAPServerInformation >> root: aString [

	rootDN := aString
]

{ #category : 'accessing' }
LDAPServerInformation >> scheme [

	^ method scheme
]

{ #category : 'accessing' }
LDAPServerInformation >> username [

	^ username
]

{ #category : 'accessing' }
LDAPServerInformation >> username: aString [

	username := aString
]
