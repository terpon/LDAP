"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'session',
		'queue',
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

	session connected ifTrue: [
		(aServerInfo = session server) ifTrue: [ ^ self ].
		self disconnect.
	].

	"triggers ValueChanged so order is important"
	session server: aServerInfo.
	
	queue connectWith: aServerInfo.

]

{ #category : 'accessing' }
LDAPBrowser >> connectedServer [

	session connected ifFalse: [ ^ nil ].
	^ session server hostname
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
	queue disconnect.

]

{ #category : 'accessing' }
LDAPBrowser >> entryFor: aDN [
"Gets entry from the cache or search it"
	| entry |
	entry := cache at: aDN ifAbsentPut: [ LDAPEntryModel new name: aDN ].
	entry needSelfRefresh ifTrue: [ self searchSelf: aDN for: entry. ].
	entry needSubRefresh ifTrue: [ self searchSub: aDN for: entry. ].
	^ entry

]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler [

	^ errorHandler ifNil: [ errorHandler := self initializeErrorPresenter ]
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	queue := LDAPRequestQueue new.
	cache := Dictionary new.
	session := LDAPSession new.
	errorLock := Semaphore forMutualExclusion.

	self subscribeToAnnouncements.
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

{ #category : 'accessing' }
LDAPBrowser >> mainPresenter [

	^ main
]

{ #category : 'callbacks' }
LDAPBrowser >> onConnect [

	session connected: true.

	self searchNamingContexts.
]

{ #category : 'callbacks' }
LDAPBrowser >> onDisconnect [

	session connected: false.

]

{ #category : 'callbacks' }
LDAPBrowser >> onNamingContexts: aCommand [

	| roots searchResult |
	searchResult := aCommand responses first asDictionary.
	roots := searchResult at: 'namingContexts' ifAbsent: [ #() ].
	session roots: roots.
]

{ #category : 'searching' }
LDAPBrowser >> onSearchResult: aCommand for: anEntry [

	| responses |
	responses := aCommand responses allButLast.
	anEntry populateFromResults: responses.
]

{ #category : 'searching' }
LDAPBrowser >> onSearchSelf: aCommand for: anEntry [

	| response |

	(aCommand responses size = 1) ifTrue: [ 
		"No result DN does not exist"
		"'report error'"
		^ self.
	].
	response := aCommand responses first.
	
	anEntry populateFromPartialAttributeList: response attributes.
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

{ #category : 'accessing' }
LDAPBrowser >> queue [
	^ queue
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

	anError ifNotNil: [ :ex | ex traceCr. "ex pass" ].
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	errorHandler reset.

]

{ #category : 'searching' }
LDAPBrowser >> searchNamingContexts [
"Search advertized root DNs"
	| request |
	session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
		
	queue sendRequest: request
		onSuccessDo: [ :command | self onNamingContexts: command ]
		onFailureDo: [ :command :error | 
			self reportException: error.
			session roots: #().
			self reportError: command. ].

]

{ #category : 'searching' }
LDAPBrowser >> searchSelf: aDN for: anEntry [
"Search will return the base node for aDN"
	| request |
	session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPBaseObjectScope new.

	queue sendRequest: request
		onSuccessDo: [ :command | self onSearchSelf: command for: anEntry ]
		onFailureDo: [ :command :error | 
			self reportException: error.
			self reportError: command. ].

]

{ #category : 'searching' }
LDAPBrowser >> searchSub: aDN for: anEntry [
"Search will return the child nodes of aDN"
	| request |
	session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPSingleLevelScope new.

	queue sendRequest: request
		onSuccessDo: [ :command | self onSearchResult: command for: anEntry ]
		onFailureDo: [ :command :error | 
			self reportException: error.
			self reportError: command. ].

]

{ #category : 'running' }
LDAPBrowser >> start [
<script: 'self start'>

	main withWindowDo: [ :w | w isOpen ifTrue:[ w activate. ^ w ] ].
	^ main open
]

{ #category : 'initialization' }
LDAPBrowser >> subscribeToAnnouncements [

	queue when: LDAPConnectionAnnouncement send: #onConnect to: self.
	queue when: LDAPDisconnectionAnnouncement send: #onDisconnect to: self.
	queue when: LDAPErrorAnnouncement do: [ :e | self reportError: e command ].
]
