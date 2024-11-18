"
I am a presenter to get LDAP server connection settings.

The data I gather will be used in `LDAPConnection` and `LDAPBindRequest` instances.
"
Class {
	#name : 'LDAPConnectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'host',
		'port',
		'ssl',
		'username',
		'password'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPConnectionPresenter class >> example [

	^ self new open

]

{ #category : 'accessing' }
LDAPConnectionPresenter >> beNonSSL [

	ssl state: false
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> beSSL [

	ssl state: true
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	ssl whenChangedDo: [ self updateDefaultPort ].
	port whenTextChangedDo: [ self updateDefaultPort ].
	self updateDefaultPort.
]

{ #category : 'layout' }
LDAPConnectionPresenter >> defaultLayout [

	^ SpGridLayout build: [ :builder |
			builder
				add: 'Hostname:'; add: host; nextRow;
				add: 'SSL:'; add: ssl; nextRow;
				add: 'Port:'; add: port; nextRow;
				add: 'Username:'; add: username; nextRow;
				add: 'Password:'; add: password
 	]
]

{ #category : 'default values' }
LDAPConnectionPresenter >> defaultPort [

	^ ssl state ifTrue: [ 636 ] ifFalse: [ 389 ]
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> hostname [

	^ host text
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> hostname: aString [

	host text: aString
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializePresenters [ 

	host := self newTextInput placeholder: 'Hostname'.
	
	port := self newNumberInput beInteger; minimum: 1; maximum: 65535; placeholder: 'Port'.
	
	ssl := self newCheckBox.
	
	username := self newTextInput placeholder: 'Username'.
	
	password := self newTextInput bePassword; placeholder: 'Password'.
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter title: 'LDAP Connection Settings'.
]

{ #category : 'testing' }
LDAPConnectionPresenter >> isSSL [

	^ ssl state
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> password [

	^ password text
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> password: aString [

	password text: aString
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> port [
	
	port text ifNotEmpty: [ ^ port number ].
	
	^ self defaultPort
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> port: aNumber [
	
	aNumber isZero ifTrue: [ port text: ''. ^ self ].
	port number: aNumber
]

{ #category : 'default values' }
LDAPConnectionPresenter >> updateDefaultPort [
	
	"Default port is only used if there is no user input"
	port text ifNotEmpty: [ ^ self ].
	
	port placeholder: self defaultPort asString.
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> username [ 

	^ username text
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> username: aString [

	username text: aString
]
