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

{ #category : 'clearing' }
LDAPBrowser >> clearCache [
"Empty cache when a new root is selected"

	cache removeAll.
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
	
	self clearCache.
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
	| aCachedEntry |
	aCachedEntry := cache at: aDN ifAbsentPut: [ LDAPCachedEntry for: aDN ].
	self isConnected ifTrue: [ aCachedEntry update: self ].
	^ aCachedEntry entry

]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler [

	^ errorHandler ifNil: [ errorHandler := self initializeErrorPresenter ]
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	cache := Dictionary new.
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

	main := LDAPInspectorPresenter
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

	session connected: true.
	main notify: ''.

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

	| roots searchResult |
	searchResult := aCommand responses first asDictionary.
	roots := searchResult at: 'namingContexts' ifAbsent: [ #() ].
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
		          attributes: { 'namingContexts' }.
		
	^ self sendRequest: request
		onSuccessDo: [ :command | self onNamingContexts: command ]
		onFailureDo: [ :command | 
			session roots: #().
			self reportError: command. ].

]

{ #category : 'enumerating' }
LDAPBrowser >> sendRequest: aRequest onSuccessDo: aBlock onFailureDo: aFailBlock [

	| task |
	task := LDAPRequestTask new 
		request: aRequest; 
		onSuccessDo: aBlock;
		onFailureDo: aFailBlock.

	^ task startOn: self
]

{ #category : 'running' }
LDAPBrowser >> start [
<script: 'self start'>

	main withWindowDo: [ :w | w isOpen ifTrue:[ w activate. ^ w ] ].
	^ main open
]
