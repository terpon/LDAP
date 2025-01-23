"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'announcer',
		'session',
		'connection',
		'errorPresenter',
		'errorHandler',
		'errorLock',
		'main',
		'cache'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'instance creation' }
LDAPBrowser class >> mainPresenterClass [

	^ LDAPInspectorPresenter
]

{ #category : 'ui - dialogs' }
LDAPBrowser class >> openConnectionDialog [
<example>

	| aLDAPBrowser |
	aLDAPBrowser := self new.
	^ aLDAPBrowser mainPresenter openConnectionDialog
]

{ #category : 'accessing - defaults' }
LDAPBrowser class >> requestPriority [

"Using Processor userBackgroundPriority result in processes stuck too often"

	^ Processor userSchedulingPriority + 1
]

{ #category : 'accessing' }
LDAPBrowser class >> start [
<example>
	^ self new start
]

{ #category : 'accessing' }
LDAPBrowser class >> theme [
	^ Smalltalk ui theme
]

{ #category : 'accessing' }
LDAPBrowser >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'connecting' }
LDAPBrowser >> connectTo: aServerInfo [

	| bind |
	self isConnected ifTrue: [
		(aServerInfo = session server) ifTrue: [ ^ self ].
		self disconnect.
	].

	"triggers ValueChanged so order is important"
	session server: aServerInfo.
	
	connection := aServerInfo newConnection.
	connection announcer when: LDAPIsConnected send: #onConnect to: self.
	connection announcer when: LDAPIsDisconnected send: #onDisconnect: to: self.
	bind := aServerInfo newBindRequest.
	
	connection requestOnConnect: bind.
	connection asyncConnect.
	"Following actions in onConnect if connection and bind successful"
]

{ #category : 'testing' }
LDAPBrowser >> connected [

	^ 	session connected
]

{ #category : 'accessing' }
LDAPBrowser >> connectedServer [

	self isConnected ifFalse: [ ^ nil ].
	^ session server hostname
]

{ #category : 'accessing' }
LDAPBrowser >> connection [
	^ connection
]

{ #category : 'accessing' }
LDAPBrowser >> currentRoot [
	
	^ session currentRoot
]

{ #category : 'accessing' }
LDAPBrowser >> currentRoot: aDN [

	(session currentRoot = aDN) ifTrue: [ ^ self ].
	
	cache root: aDN.
	session currentRoot: aDN.
]

{ #category : 'coloring' }
LDAPBrowser >> defaultColor [

	^ (SHRBTextStyler attributesFor: #default) ifEmpty: [ self class theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'coloring' }
LDAPBrowser >> disabledColor [

	^ self class theme disabledTextColor
]

{ #category : 'running' }
LDAPBrowser >> disconnect [

	session connected: false.
	connection ifNil: [ ^self ].
	
	"Fork to avoid to block UI on slow servers"
	[ connection disconnect ] forkAt: self class requestPriority named: 'LDAP disconnect'.

]

{ #category : 'coloring' }
LDAPBrowser >> emphasisColor [

	^ (SHRBTextStyler attributesFor: #instVar) ifEmpty: [ self class theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'searching' }
LDAPBrowser >> entryFor: aDN [
"Gets entry from the cache or search it"
	| aCachedEntry |
	aCachedEntry := cache at: aDN.
	aDN isEmptyOrNil ifTrue: [ ^ aCachedEntry entry ].
	self isConnected ifTrue: [ aCachedEntry update: self ].
	^ aCachedEntry entry

]

{ #category : 'coloring' }
LDAPBrowser >> errorColor [

	^ (SHRBTextStyler attributesFor: #invalid) ifEmpty: [ Color red ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler [

	^ errorHandler ifNil: [ errorHandler := LDAPErrorQueueModel new ]
]

{ #category : 'accessing' }
LDAPBrowser >> errorPresenter [

	^ errorPresenter ifNil: [ self initializeErrorPresenter ]
]

{ #category : 'coloring' }
LDAPBrowser >> formattedTextFor: aDN [

	| parts |
	parts := LDAPName splitInThird: aDN root: session currentRoot.
	parts second isEmpty & parts third isEmpty ifTrue: [ ^ aDN ].
	^ Text streamContents: [ :stream |
		stream nextPutAll: (Text string: parts first attribute: (TextColor color: self emphasisColor)).
		parts second ifNotEmpty: [ :string |
			stream nextPutAll: ','; nextPutAll: string 
		].
		parts third ifNotEmpty: [ :string |
			stream nextPutAll: ','; nextPutAll: (Text string: string attribute: (TextColor color: self disabledColor))
		].
	]
]

{ #category : 'private' }
LDAPBrowser >> inform: aString [

	main notify: aString.
	super inform: aString
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	cache := LDAPCache new.
	session := LDAPSession new.
	errorLock := Semaphore forMutualExclusion.

	self initializeMainPresenter.

]

{ #category : 'initialization' }
LDAPBrowser >> initializeErrorPresenter [

	^ errorPresenter := LDAPErrorPresenter newApplication: self model: self errorHandler


]

{ #category : 'initialization' }
LDAPBrowser >> initializeMainPresenter [

	main := self class mainPresenterClass
		          newApplication: self
		          model: session.


]

{ #category : 'testing' }
LDAPBrowser >> isConnected [

	^ 	session connected
]

{ #category : 'accessing' }
LDAPBrowser >> mainPresenter [

	^ main
]

{ #category : 'callbacks' }
LDAPBrowser >> onConnect [

	main notify: 'connected'.
	session connected: true.

	self requestDirectorySpecificEntry.
	
	"Announce to my subscribers"
	self announcer announce: LDAPIsConnected new.

]

{ #category : 'callbacks' }
LDAPBrowser >> onDirectorySpecificEntry: aCommand [

	| searchResult |
	main notify: 'directory specific entry retrieved'.
	searchResult := aCommand responses first asDictionary.
	session directorySpecificEntry: searchResult.
]

{ #category : 'callbacks' }
LDAPBrowser >> onDisconnect: anAnnouncement [

	| ex |
	ex := anAnnouncement cause.
	session connected: false.
	main notify: (ex ifNil: [ 'disconnected' ] ifNotNil: [ ex description ] ).

	"Forward to my subscribers"
	self announcer announce: anAnnouncement.

]

{ #category : 'enumerating' }
LDAPBrowser >> openCustomRootDialog [

	| dialog |
	dialog := self newRequest
		title: 'Custom Naming Context';
		label: 'Enter new root DN:'.
	dialog openDialog.
	^ dialog
]

{ #category : 'enumerating' }
LDAPBrowser >> openErrorWindow [

	^ self errorPresenter
		withWindowDo: [ :w | w isOpen ifTrue:[ w activate. ^ w ] ];
		last;
		open
]

{ #category : 'private' }
LDAPBrowser >> reportError: aResult [

	errorLock critical: [ 
		self errorHandler report: aResult
	].

	self openErrorWindow.


]

{ #category : 'private' }
LDAPBrowser >> reportException: anError [

	anError ifNotNil: [ :ex | 
		main notify: ex printString.
		ex traceCr. "ex pass" 
	].
]

{ #category : 'searching' }
LDAPBrowser >> requestDirectorySpecificEntry [
"Search advertized root DNs and other server information"
	| request |
	self isConnected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { '*' . '+' }.
		
	^ self sendRequest: request
		onSuccessDo: [ :command | self onDirectorySpecificEntry: command ]
		onFailureDo: [ :command | 
			session clearDirectorySpecificEntry.
			self reportError: command. ].

]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	self errorHandler removeAll.

]

{ #category : 'enumerating' }
LDAPBrowser >> sendAndWaitFor: aRequest onSuccessDo: aBlock onFailureDo: aFailBlock [

	| task |
	task := LDAPRequestTask new 
		request: aRequest; 
		onSuccessDo: aBlock;
		onFailureDo: aFailBlock.

	self isConnected ifFalse: [ ^ task fail ].

	^ task waitOn: self connection
]

{ #category : 'enumerating' }
LDAPBrowser >> sendRequest: aRequest onSuccessDo: aBlock onFailureDo: aFailBlock [

	| task |
	task := LDAPRequestTask new 
		request: aRequest; 
		onSuccessDo: aBlock;
		onFailureDo: aFailBlock.

	self isConnected ifFalse: [ ^ task fail ].

	^ task startOn: self connection
]

{ #category : 'running' }
LDAPBrowser >> start [
<script: 'self start'>

	main withWindowDo: [ :w | w isOpen ifTrue:[ w activate. ^ w ] ].
	^ main open
]
