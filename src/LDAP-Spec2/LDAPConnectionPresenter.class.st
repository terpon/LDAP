"
I am a presenter to get LDAP server connection settings.

The data I gather will be used in `LDAPConnection` and `LDAPBindRequest` instances.
"
Class {
	#name : 'LDAPConnectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'port',
		'ssl',
		'username',
		'password',
		'hostname',
		'acceptBlock'
	],
	#category : 'LDAP-Spec2-Connection',
	#package : 'LDAP-Spec2',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPConnectionPresenter class >> currentApplication [

	^ LDAPBrowser new
]

{ #category : 'examples' }
LDAPConnectionPresenter class >> example [
	| model presenter |
	presenter := self new.
	model := LDAPSession new
		hostname: 'localhost';
		port: 777;
		username: 'cn=user,cn=example,cn=com';
		password: '12345678';
		yourself.
	presenter fromSession: model.
	^ presenter openDialog
]

{ #category : 'examples' }
LDAPConnectionPresenter class >> exampleEmpty [

	^ self new openDialog
]

{ #category : 'instance creation' }
LDAPConnectionPresenter class >> new [

	^ self newApplication: self currentApplication
]

{ #category : 'callbacks' }
LDAPConnectionPresenter >> accept [

	acceptBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	ssl whenChangedDo: [ :state | self updateDefaultPort ].
	
]

{ #category : 'layout' }
LDAPConnectionPresenter >> defaultLayout [

	^ SpGridLayout build: [ :builder |
			builder
				beColumnNotHomogeneous;
				column: 2 expand: true;
				add: 'Hostname:'; add: hostname; nextRow;
				add: 'SSL:'; add: ssl; nextRow;
				add: 'Port:'; add: port; nextRow;
				add: 'Username:'; add: username; nextRow;
				add: 'Password:'; add: password
 	]
]

{ #category : 'default values' }
LDAPConnectionPresenter >> defaultPort [

	^ self isSSL ifTrue: [ 636 ] ifFalse: [ 389 ]
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> fromSession: aSession [

	hostname text: (aSession hostname ifNil: [ '' ]).
	port number: aSession port.
	ssl state: aSession isSSL.
	username text: (aSession username ifNil: [ '' ]).
	password text: (aSession password ifNil: [ '' ]).

]

{ #category : 'accessing' }
LDAPConnectionPresenter >> hostname [

	^ hostname text
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializeDialogWindow: aDialogPresenter [

	aDialogPresenter 
		withDecorations;
		addButton: 'Cancel' do: [ :dialog | dialog close ];
		addButton: 'OK' do: [ :dialog | self accept. dialog beOk; close ].
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializePresenters [ 

	hostname := self newTextInput placeholder: 'Hostname'.
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

{ #category : 'accessing' }
LDAPConnectionPresenter >> isSSL [ 

	^ ssl state
]

{ #category : 'events' }
LDAPConnectionPresenter >> onAccept: aBlock [

	acceptBlock := aBlock
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> password [ 

	^ password text
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> port [ 
	
	^ port text ifEmpty: [ self defaultPort ] ifNotEmpty: [ port number ]
]

{ #category : 'accessing - model' }
LDAPConnectionPresenter >> setModel: aModel [

	application session: aModel.
	self updatePresenter 
	
]

{ #category : 'accessing - model' }
LDAPConnectionPresenter >> setModelBeforeInitialization: aModel [

	application session: aModel
]

{ #category : 'default values' }
LDAPConnectionPresenter >> updateDefaultPort [
	
	"Clear value if default"
	(port number = self defaultPort) ifTrue: [ port text: '' ].
	
	"Default port is only used if there is no user input"
	port text ifNotEmpty: [ ^ self ].
	
	port placeholder: (self defaultPort) asString.
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> updatePresenter [ 

	self fromSession: application session.
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> username [ 

	^ username text
]
