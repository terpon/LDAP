"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'session',
		'connection',
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

{ #category : 'accessing' }
LDAPBrowser class >> start [
<example>
	^ self new start
]

{ #category : 'circuit setup' }
LDAPBrowser >> connectTo: aServerInfo [

	| bind |
	self isConnected ifTrue: [
		(aServerInfo = session server) ifTrue: [ ^ self ].
		self disconnect.
	].

	"triggers ValueChanged so order is important"
	session server: aServerInfo.
	
	connection := aServerInfo newConnection.
	connection when: LDAPIsConnected send: #onConnect to: self.
	connection when: LDAPIsDisconnected send: #onDisconnect: to: self.
	bind := aServerInfo newBindRequest.
	
	connection requestOnConnect: bind.
	connection connect.
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

{ #category : 'running' }
LDAPBrowser >> disconnect [

	session connected: false.
	connection ifNotNil: [ connection disconnect ].

]

{ #category : 'accessing' }
LDAPBrowser >> entryFor: aDN [
"Gets entry from the cache or search it"
	^ cache at: aDN for: self

]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler [

	^ errorHandler ifNil: [ errorHandler := self initializeErrorPresenter ]
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

	^ LDAPErrorPresenter newApplication: self model: LDAPErrorQueueModel new


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

	main notify: ''.
	session connected: true.

	self searchNamingContexts.
]

{ #category : 'callbacks' }
LDAPBrowser >> onDisconnect: anAnnouncement [

	| ex |
	ex := anAnnouncement cause.
	session connected: false.
	main notify: (ex ifNil: [ 'disconnected' ] ifNotNil: [ ex className ] ).

]

{ #category : 'callbacks' }
LDAPBrowser >> onNamingContexts: aCommand [

	| roots subSchema searchResult |
	searchResult := aCommand responses first asDictionary.
	
	subSchema := searchResult at: 'subschemasubentry' ifPresent: [ :c | c first ] ifAbsent: [ nil ].
	session subSchema: subSchema.
	
	roots := searchResult at: 'namingcontexts' ifAbsent: [ #() ].
	session roots: roots.
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

	| presenter |
	presenter := self errorHandler.
	presenter withWindowDo: [ :w | w isOpen ifTrue:[ w activate. ^ w ] ].
	^ presenter open.
]

{ #category : 'private' }
LDAPBrowser >> reportError: aResult [

	errorLock critical: [ 
		self openErrorWindow.
		errorHandler model report: aResult
	].
]

{ #category : 'private' }
LDAPBrowser >> reportException: anError [

	anError ifNotNil: [ :ex | 
		main notify: ex printString.
		ex traceCr. "ex pass" 
	].
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	errorHandler reset.

]

{ #category : 'searching' }
LDAPBrowser >> searchNamingContexts [
"Search advertized root DNs"
	| request |
	self isConnected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { '*' . '+' }.
		
	^ self sendRequest: request
		onSuccessDo: [ :command | self onNamingContexts: command ]
		onFailureDo: [ :command | 
			session roots: #().
			self reportError: command. ].

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
