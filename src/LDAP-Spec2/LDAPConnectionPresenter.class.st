"
I am a presenter to get LDAP server connection settings.

The data I gather will be used in `LDAPConnection` and `LDAPBindRequest` instances.
"
Class {
	#name : 'LDAPConnectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'serverInfo',
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

{ #category : 'specs' }
LDAPConnectionPresenter class >> title [

	^ 'LDAP Connection Settings'
]

{ #category : 'callbacks' }
LDAPConnectionPresenter >> accept [

	acceptBlock ifNotNil: [ :block | block cull: serverInfo ]
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	hostname whenTextChangedDo: [ :text | serverInfo hostname: text ] .
	ssl whenChangedDo: [ :state | serverInfo ssl: state. self updateDefaultPort ].
	port whenNumberChangedDo: [ :number | serverInfo port: number ] .
	username whenTextChangedDo: [ :text | serverInfo username: text ] .
	password whenTextChangedDo: [ :text | serverInfo password: text ] .
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
LDAPConnectionPresenter >> initialize [

	super initialize.

	serverInfo ifNil: [ serverInfo := LDAPServerInfo new ].
	

]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializeDialogWindow: aDialogPresenter [

	| ok |
	aDialogPresenter 
		withDecorations;
		addButton: 'Cancel' do: [ :dialog | dialog close ].
		
	ok := aDialogPresenter addButton: 'OK' do: [ :dialog | self accept. dialog beOk; close ].
		
	hostname text ifNotEmpty: [ :text | aDialogPresenter whenOpenedDo: [ ok takeKeyboardFocus ] ].


]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializePresenters [ 

	hostname := self newTextInput placeholder: 'Hostname'.
	port := self newNumberInput beInteger; minimum: 1; maximum: 65535; placeholder: 'Port'.
	ssl := self newCheckBox.
	username := self newTextInput placeholder: 'Username'.
	password := self newTextInput bePassword; placeholder: 'Password'.
]

{ #category : 'events' }
LDAPConnectionPresenter >> onAccept: aBlock [

	acceptBlock := aBlock
]

{ #category : 'accessing - model' }
LDAPConnectionPresenter >> setModel: aServerInfo [

	serverInfo := aServerInfo.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPConnectionPresenter >> setModelBeforeInitialization: aServerInfo [

	serverInfo := aServerInfo
]

{ #category : 'default values' }
LDAPConnectionPresenter >> updateDefaultPort [
	| default wasDefault |
	default := serverInfo defaultPort.
	port placeholder: default asString.	

	"Clear value if default"
	wasDefault := LDAPServerInfo defaultPortForSSL: ssl state not.
	(port number = wasDefault) ifTrue: [ port text: '' ].

]

{ #category : 'initialization' }
LDAPConnectionPresenter >> updatePresenter [
 
	hostname text: serverInfo hostname.
	ssl state: serverInfo isSSL.
	self updateDefaultPort.
	port text: ((serverInfo port = serverInfo defaultPort) ifTrue: [ '' ] ifFalse: [ serverInfo port asString ]).
	username text: serverInfo username.
	password text: serverInfo password.
	

]
