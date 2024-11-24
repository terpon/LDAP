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
		'hostname',
		'acceptBlock'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPConnectionPresenter class >> example [
	| model presenter |
	model := LDAPServerInfo new
		hostname: 'localhost';
		port: 777;
		username: 'cn=user,cn=example,cn=com';
		password: '12345678';
		yourself.
	presenter := self on: model.
	^ presenter openDialog
]

{ #category : 'examples' }
LDAPConnectionPresenter class >> exampleEmpty [

	^ self new openDialog
]

{ #category : 'callbacks' }
LDAPConnectionPresenter >> accept [

	acceptBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	hostname whenTextChangedDo: [ :text | self model ifNotNil: [ :m | m hostname: text ] ] .
	ssl whenChangedDo: [ :state | self model ifNotNil: [ :m | m ssl: state ]. self updateDefaultPort ].
	port whenNumberChangedDo: [ :number | self model ifNotNil: [ :m | m port: number ] ] .
	username whenTextChangedDo: [ :text | self model ifNotNil: [ :m | m username: text ] ] .
	password whenTextChangedDo: [ :text | self model ifNotNil: [ :m | m password: text ] ] .
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
	| server |
	server := self model.
	server ifNil: [ ^ self ].
	
	hostname text: server hostname.
	ssl state: server isSSL.
	port number: server port.
	username text: server username.
	password text: server password.
]

{ #category : 'events' }
LDAPConnectionPresenter >> onAccept: aBlock [

	acceptBlock := aBlock
]

{ #category : 'default values' }
LDAPConnectionPresenter >> updateDefaultPort [
	| default wasDefault |
	default := self model defaultPort.
	port placeholder: default asString.	

	"Clear value if default"
	wasDefault := LDAPServerInfo defaultPortForSSL: ssl state not.
	(port number = wasDefault) ifTrue: [ port text: '' ].

]
