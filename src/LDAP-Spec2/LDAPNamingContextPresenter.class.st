"
I am an interface to query published root DNs from a server.

If the server information provides a password, I send a bind request before querying the naming contexts.
"
Class {
	#name : 'LDAPNamingContextPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'query',
		'cancel',
		'copy',
		'roots',
		'copyAction',
		'serverBlock',
		'status',
		'queryProcess',
		'connection'
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
		onCopyDo: [ :root | presenter inform: root ].
		
	^ presenter open title: 'LDAP localhost'; yourself
]

{ #category : 'callbacks' }
LDAPNamingContextPresenter >> cancel [

	queryProcess ifNil: [ ^self ].
	queryProcess terminate.
	queryProcess := nil.
]

{ #category : 'callbacks' }
LDAPNamingContextPresenter >> copySelected [

	| aDN |
	aDN := roots selectedItem ifNil: [ ^self ].
	copyAction ifNotNil: [ :block | block cull: aDN ]
]

{ #category : 'layout' }
LDAPNamingContextPresenter >> defaultLayout [ 

	^ 	SpBoxLayout newTopToBottom
			add: (SpBoxLayout newLeftToRight vAlignCenter; 
				add: query expand: false; 
				add: cancel expand: false; 
				add: roots; 
				add: copy expand: false; 
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
		copy enabled: false.
		query enabled: true.
		cancel enabled: false.
	].

	queryProcess := nil.
]

{ #category : 'initialization' }
LDAPNamingContextPresenter >> initializePresenters [ 

	status := self newTextInput beNotEditable.
	
	roots := self newDropList
	   display: [ :dn | dn ];
		yourself.
	
	query := self newButton 
		label: 'Query';
		icon: (self iconNamed: #testNotRun);
		help: 'query the naming contexts from the current server information';
		action: [ self query ];
		yourself.
		
	cancel := self newButton addStyle: 'small';
		icon: (self iconNamed: #smallCancel);
		help: 'Cancel the current query';
		action: [ self cancel; fail: 'cancelled' ];
		yourself.

	copy := self newButton addStyle: 'small';
		icon: (self iconNamed: #smallCopy);
		help: 'Copy the current selected naming context to the bookmark root DN field';
		action: [ self copySelected ];
		yourself.
	
	self reset
]

{ #category : 'api - events' }
LDAPNamingContextPresenter >> onCopyDo: aBlock [
"Callback when the copy button is clicked"
	copyAction := aBlock 
]

{ #category : 'private' }
LDAPNamingContextPresenter >> pass: aCollection [

	self defer: [ 
		| isEnabled |
		isEnabled := aCollection isNotEmpty.
		status text: ('success: number of naming contexts: {1}' format: { aCollection size }).
		roots items: aCollection; enabled: isEnabled.
		copy enabled: isEnabled.
		query icon: (self iconNamed: #testGreen).
		query enabled: true.
		cancel enabled: false.
	].

	queryProcess := nil.
]

{ #category : 'callbacks' }
LDAPNamingContextPresenter >> query [

	| aServerInformation |
	aServerInformation := self serverInformation ifNil: [ ^self ].
	aServerInformation hostname ifEmpty: [ ^self ].
	
	self reset.
	status text: 'querying in progress'.
	query enabled: false; icon: (self iconNamed: #testYellow).
	queryProcess := [ self query: aServerInformation ] fork.
	cancel enabled: true.
]

{ #category : 'private' }
LDAPNamingContextPresenter >> query: aServerInformation [

	| aCollection |
	aCollection := [ 
		connection := aServerInformation newConnection.
		connection connect.
		connection isConnected ifFalse: [ ^self fail: 'Cannot connect to server' ].
		(self queryBind: aServerInformation) ifFalse: [ ^self fail: 'Authentification failure' ].
	
		self queryNamingContexts ifNil: [ ^self fail: 'Querying naming context failed' ]
	] ensure: [ 
		connection ifNotNil: [ connection disconnect ].
		connection := nil
	].
	^ self pass: aCollection
]

{ #category : 'private' }
LDAPNamingContextPresenter >> queryBind: aServerInformation [

	| aCommand |
	aServerInformation hasUserCredentials ifFalse: [ ^ true ].
	
	aCommand := connection request: aServerInformation newBindRequest.
	aCommand ifNil: [ ^ false ]. "disconnected"
	aCommand wait.
	^ aCommand success
]

{ #category : 'private' }
LDAPNamingContextPresenter >> queryNamingContexts [

	| aCommand aLDAPRequest aResult |
	aLDAPRequest := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
	aCommand := connection request: aLDAPRequest.
	aCommand ifNil: [ ^ false ]. "disconnected"
	aCommand wait.
	aCommand success	ifFalse: [ ^ false ]. "no such object"
	aResult := aCommand responses first asDictionary.
	^ aResult at: 'namingcontexts' ifAbsent: [ #() ]
]

{ #category : 'api' }
LDAPNamingContextPresenter >> reset [

	queryProcess ifNotNil: [ ^self ].
	status text: ''.
	query enabled: true; icon: (self iconNamed: #testNotRun).
	cancel enabled: false.
	roots enabled: false; items: #().
	copy enabled: false.
]

{ #category : 'private' }
LDAPNamingContextPresenter >> serverInformation [

	^ serverBlock ifNotNil: [ :block | block cull: self ]
]

{ #category : 'api - model' }
LDAPNamingContextPresenter >> whichServer: aBlock [
"The block will be called when the query button is pressed to retrieve the server information"

	serverBlock := aBlock 
]
