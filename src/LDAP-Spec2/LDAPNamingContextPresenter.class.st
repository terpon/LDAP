"
I am an interface to query published root DNs from a server.

If the server information provides a password, I send a bind request before querying the naming contexts.
"
Class {
	#name : 'LDAPNamingContextPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'query',
		'roots',
		'rootAction',
		'serverBlock',
		'status',
		'queryProcess'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'examples' }
LDAPNamingContextPresenter class >> example [

	| presenter |
	presenter := self new.
	presenter
		whichServer: [ LDAPServerInformation new hostname: 'localhost'; yourself ];
		whenRootChangedDo: [ :root | presenter inform: root ].
		
	^ presenter open title: 'LDAP localhost'; yourself
]

{ #category : 'layout' }
LDAPNamingContextPresenter >> defaultLayout [ 

	^ 	SpBoxLayout newTopToBottom
			add: (SpBoxLayout newLeftToRight vAlignCenter; 
				add: query expand: false; 
				add: roots; 
				yourself) expand: false;
		add: status expand: false;
		yourself.

]

{ #category : 'private' }
LDAPNamingContextPresenter >> fail: aReason [

	self defer: [ 
		status text: aReason.
		query icon: (self iconNamed: #testRed).
		roots enabled: false; items: #().
		query enabled: true.
	].

	queryProcess := nil.
]

{ #category : 'initialization' }
LDAPNamingContextPresenter >> initializePresenters [ 

	status := self newTextInput beNotEditable.
	
	roots := self newDropList
	   display: [ :dn | dn ];
		whenSelectionChangedDo: [ self rootChanged ];
		enabled: false;
		yourself.
	
	query := self newButton 
		label: 'Query';
		icon: (self iconNamed: #testNotRun);
		help: 'query the naming contexts from the current server information';
		action: [ self query ];
		yourself.
]

{ #category : 'private' }
LDAPNamingContextPresenter >> pass: aCollection [

	| items |
	items := #( '' ) copyWithAll: aCollection.
	self defer: [ 
		status text: ''.
		roots items: items; enabled: true.
		query icon: (self iconNamed: #testGreen).
		query enabled: true.
	].

	queryProcess := nil.

]

{ #category : 'callbacks' }
LDAPNamingContextPresenter >> query [

	| aServerInformation |
	aServerInformation := self serverInformation ifNil: [ ^self ].
	aServerInformation hostname ifEmpty: [ ^self ].
	
	status text: 'querying in progress'.
	query enabled: false; icon: (self iconNamed: #testYellow).
	queryProcess := [ self query: aServerInformation ] fork
]

{ #category : 'private' }
LDAPNamingContextPresenter >> query: aServerInformation [

	| connection aCollection |
	connection := aServerInformation newConnection.
	connection connect.
	connection isConnected ifFalse: [ ^self fail: 'Cannot connect to server' ].
	(self queryBind: aServerInformation on: connection) ifFalse: [ ^self fail: 'Authentification failure' ].
	
	aCollection := self queryNamingContexts: connection.
	aCollection ifNil: [ ^self fail: 'Querying naming context failed' ].
	
	^ self pass: aCollection
]

{ #category : 'private' }
LDAPNamingContextPresenter >> queryBind: aServerInformation on: aConnection [

	| aCommand |
	aServerInformation hasUserCredentials ifFalse: [ ^ true ].
	
	aCommand := aConnection request: aServerInformation newBindRequest.
	aCommand ifNil: [ ^ false ]. "disconnected"
	aCommand wait.
	aCommand isDone ifFalse: [ ^ false ]. "timeout"
	^ aCommand success
]

{ #category : 'private' }
LDAPNamingContextPresenter >> queryNamingContexts: aConnection [

	| aCommand aLDAPRequest aResult |
	aLDAPRequest := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
	aCommand := aConnection request: aLDAPRequest.
	aCommand ifNil: [ ^ false ]. "disconnected"
	aCommand wait.
	aCommand isDone ifFalse: [ ^ false ]. "timeout"
	aCommand success	ifFalse: [ ^ false ]. "no such object"
	aResult := aCommand responses first asDictionary.
	^ aResult at: 'namingcontexts' ifAbsent: [ #() ]
]

{ #category : 'api' }
LDAPNamingContextPresenter >> reset [

	queryProcess ifNotNil: [ ^self ].
	status text: ''.
	query enabled: true; icon: (self iconNamed: #testNotRun).
	roots enabled: false; items: #().
]

{ #category : 'callbacks' }
LDAPNamingContextPresenter >> rootChanged [

	| root |
	root := roots selectedItem ifNil: [ ^self ].
	rootAction ifNotNil: [ :block | block cull: root ]
]

{ #category : 'private' }
LDAPNamingContextPresenter >> serverInformation [

	^ serverBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'api - events' }
LDAPNamingContextPresenter >> whenRootChangedDo: aBlock [

	rootAction := aBlock 
]

{ #category : 'api - model' }
LDAPNamingContextPresenter >> whichServer: aBlock [
"The block will be called when the query button is pressed to retrieve the server information"

	serverBlock := aBlock 
]
