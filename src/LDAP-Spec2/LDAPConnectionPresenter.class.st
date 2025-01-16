"
I am a presenter to get LDAP server connection settings.

The data I gather will be used in `LDAPConnection` and `LDAPBindRequest` instances.
"
Class {
	#name : 'LDAPConnectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'previousType',
		'port',
		'username',
		'password',
		'hostname',
		'rootName',
		'method'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'examples' }
LDAPConnectionPresenter class >> example [
	| model presenter |
	model := LDAPServerInformation new
		hostname: 'localhost';
		port: 777;
		root: 'ou=people,cn=example,cn=com';
		username: 'cn=user,cn=example,cn=com';
		password: '12345678';
		yourself.
	presenter := self new serverInformation: model.
	^ presenter openDialog
		okAction: [ :d | d inform: 'OK' ];
		cancelAction: [ :d | d inform: 'Cancel' ];
		yourself
]

{ #category : 'examples' }
LDAPConnectionPresenter class >> exampleEmpty [

	^ self new openDialog
]

{ #category : 'specs' }
LDAPConnectionPresenter class >> title [

	^ 'LDAP Connection Settings'
]

{ #category : 'converting' }
LDAPConnectionPresenter >> asServerInformation [

	^ LDAPServerInformation new
		hostname: self hostname;
		method: self method;
		port: self port;
		username: self username;
		password: self password;
		root: self rootName;
		yourself
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> connectPresenters [ 

	method whenSelectedItemChangedDo: [ self updatePort ].
]

{ #category : 'layout' }
LDAPConnectionPresenter >> defaultLayout [

	^ SpGridLayout build: [ :builder |
			builder
				beColumnNotHomogeneous;
				column: 2 expand: true;
				add: 'Hostname:'; add: hostname; nextRow;
				add: 'Method:'; add: method; nextRow;
				add: 'Port:'; add: port; nextRow;
				add: 'Username:'; add: username; nextRow;
				add: 'Password:'; add: password; nextRow;
				add: 'Root:'; add: rootName
 	]
]

{ #category : 'accessing - defaults' }
LDAPConnectionPresenter >> defaultPort [

	^ self method defaultPort
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> hostname [

	^ hostname text
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializeDialogWindow: aDialogPresenter [

	super initializeDialogWindow: aDialogPresenter.
		
	hostname text ifNotEmpty: [ aDialogPresenter whenOpenedDo: [ aDialogPresenter defaultButton takeKeyboardFocus ] ].


]

{ #category : 'initialization' }
LDAPConnectionPresenter >> initializePresenters [ 

	hostname := self newTextInput placeholder: 'Hostname'; help: 'Server host name or IP address'.
	port := self newNumberInput beInteger; minimum: 1; maximum: 65535; placeholder: 'Port'.
	method := self newDropList help: 'Connection method to the server';
		items: (LDAPConnectionType allSubclasses reject: #isAbstract thenCollect: #new);
		display: [ :t | t presenterText ];
		yourself.
	rootName := self newTextInput placeholder: 'Root DN'; help: 'Start entry name.', String cr, ' Keep empty to use server first Naming Context'.
	username := self newTextInput placeholder: 'Username'; help: 'User full Distinguished Name'.
	password := self newTextInput bePassword; placeholder: 'Password'.
]

{ #category : 'transmission' }
LDAPConnectionPresenter >> inputModelPort [

	^ SpActionPort newAction: [ :anObject | self serverInformation: anObject ]
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> method [

	^ method selectedItem
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> password [

	^ password text
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> port [

	(port text isEmpty or: [ port number isZero ]) ifTrue: [ ^ self defaultPort ].
	^ port number
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> rootName [

	^ rootName
]

{ #category : 'converting' }
LDAPConnectionPresenter >> serverInformation: anObject [
 
	hostname text: anObject hostname.
	port number: anObject port.
	method selectItem: anObject method.
	self updatePort.
	username text: anObject username.
	password text: anObject password.
	rootName text: anObject root.
]

{ #category : 'updating - presenters' }
LDAPConnectionPresenter >> updatePort [
	| previousDefault wasDefault newType |
	port number isZero ifTrue: [ port text: '' ].
	previousDefault := previousType ifNil: [ 0 ] ifNotNil: [ :t | t defaultPort ].
	wasDefault := port number = previousDefault.
	wasDefault ifTrue: [ port text: '' ].
	
	newType := method selectedItem.
	port placeholder: newType defaultPort asString.
	previousType := newType.
]

{ #category : 'initialization' }
LDAPConnectionPresenter >> updatePresenter [ 

	self updatePort 
]

{ #category : 'accessing' }
LDAPConnectionPresenter >> username [

	^ username text
]
