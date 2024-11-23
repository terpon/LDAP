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
		'main',
		'cache'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
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

	self disconnect.
	
	"triggers ValueChanged so order is important"
	session server: aServerInfo.
	
	queue connectWith: aServerInfo.

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

	^ errorHandler
]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler: anObject [

	errorHandler := anObject
	
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	errorHandler := LDAPDialogErrorHandler new application: self.

	queue := LDAPRequestQueue new.
	queue onErrorDo: [ :task | self errorHandler report: task result ].
	self subscribeToAnnouncements.
	
	cache := Dictionary new.

	session := LDAPSession new.
	self initializeMainPresenter 
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
	| search |

	session connected: true.

	search := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
		
	queue sendRequest: search onResultDo: [ :command | self onNamingContexts: command ].

]

{ #category : 'callbacks' }
LDAPBrowser >> onDisconnect [

	session connected: false.

]

{ #category : 'callbacks' }
LDAPBrowser >> onNamingContexts: aCommand [

	| roots searchResult |
	aCommand success ifFalse: [ session roots: #(). ^ self ].
	 
	searchResult := aCommand responses first asDictionary.
	roots := searchResult at: 'namingContexts' ifAbsent: [ #() ].
	session roots: roots.
]

{ #category : 'searching' }
LDAPBrowser >> onSearchResult: aCommand for: anEntry [
	| responses |
	aCommand success ifFalse: [ ^ self ].
	responses := aCommand responses allButLast.
	
	anEntry populateFromResults: responses.
]

{ #category : 'searching' }
LDAPBrowser >> onSearchSelf: aCommand for: anEntry [
	| response |
	aCommand success ifFalse: [ ^ self ].
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

{ #category : 'accessing' }
LDAPBrowser >> queue [
	^ queue
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	errorHandler reset.

]

{ #category : 'searching' }
LDAPBrowser >> searchSelf: aDN for: anEntry [
"Search will return the base node for aDN"
	| request |
	session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPBaseObjectScope new.

	queue sendRequest: request onResultDo: [ :command | self onSearchSelf: command for: anEntry ].

]

{ #category : 'searching' }
LDAPBrowser >> searchSub: aDN for: anEntry [
"Search will return the child nodes of aDN"
	| request |
	session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPSingleLevelScope new.

	queue sendRequest: request onResultDo: [ :command | self onSearchResult: command for: anEntry ].

]

{ #category : 'running' }
LDAPBrowser >> start [
<script: 'self start'>

	^ main open
]

{ #category : 'initialization' }
LDAPBrowser >> subscribeToAnnouncements [

	queue when: LDAPSessionConnected do: [ self onConnect ].
	queue when: LDAPSessionDisconnected do: [ self onDisconnect ].

]
