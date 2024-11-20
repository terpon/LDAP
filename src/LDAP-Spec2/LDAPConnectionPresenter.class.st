"
I am a presenter to get LDAP server connection settings.

The data I gather will be used in `LDAPConnection` and `LDAPBindRequest` instances.
"
Class {
	#name : 'LDAPConnectionPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'port',
		'ssl',
		'username',
		'password',
		'hostname'
	],
	#category : 'LDAP-Spec2-Connection',
	#package : 'LDAP-Spec2',
	#tag : 'Connection'
}

{ #category : 'examples' }
LDAPConnectionPresenter class >> example [
	| model presenter |
	model := LDAPConnectionModel new
		hostname: 'localhost';
		port: 777;
		username: 'cn=user,cn=example,cn=com';
		password: '12345678';
		yourself.
	presenter := self on: model.
	^ presenter openDialog
]

{ #category : 'ui - notifying' }
LDAPConnectionPresenter >> accept [
	(self application == SpApplication defaultApplication) ifTrue: [ ^self ].
	self application connectionAccept: self model
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	hostname whenTextChangedDo: [ :text | self model hostname: text ].
	ssl whenChangedDo: [ :state | self model ssl: state ].
	port whenTextChangedDo: [ :text | self model port: (text ifEmpty: [ nil ] ifNotEmpty: [ text asInteger ]). self updateDefaultPort ].
	username whenTextChangedDo: [ :text | self model username: text ].
	password whenTextChangedDo: [ :text | self model password: text ].
	
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

{ #category : 'initialization' }
LDAPConnectionPresenter >> modelChanged [
	| model |
	model := self model.
	hostname text: (model hostname ifNil: [ '' ]).
	model port ifNotNil: [ :p | port number: p ] ifNil: [ port text: '' ].
	ssl state: model isSSL.
	username text: (model username ifNil: [ '' ]).
	password text: (model password ifNil: [ '' ]).

]

{ #category : 'default values' }
LDAPConnectionPresenter >> updateDefaultPort [
	
	"Clear value if default"
	(port number = self model defaultPort) ifTrue: [ port text: '' ].
	
	"Default port is only used if there is no user input"
	port text ifNotEmpty: [ ^ self ].
	
	port placeholder: (self model defaultPort) asString.
]
