"
I am the main presenter of the LDAP browser.

Each level of the directory is on a page of the miller list.
"
Class {
	#name : 'LDAPInspectorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'customRoot',
		'currentRoot',
		'cache',
		'dropRoot',
		'miller',
		'statusBar',
		'connection'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'clearing' }
LDAPInspectorPresenter >> clearCache [
"Empty cache when a new root is selected"

	cache removeAll.
]

{ #category : 'callbacks' }
LDAPInspectorPresenter >> connectionAccept: aPresenter [
	| window |
	application disconnect.
	application session server: aPresenter model.
	application connect.
	
	window := self window.
	window ifNil: [ ^ self open ].
	window isClosed ifTrue: [ ^ window open ].
]

{ #category : 'accessing' }
LDAPInspectorPresenter >> customRoot: aString [

	customRoot := aString.
	self updateRoots 
]

{ #category : 'layout' }
LDAPInspectorPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight 
			add: connection expand: false;
			add: dropRoot;
			yourself) expand: false;
		add: miller;
		add: statusBar expand: false;
		yourself
]

{ #category : 'accessing' }
LDAPInspectorPresenter >> entryFor: aDN [
"Gets entry from the cache or search it"
	| entry |
	entry := cache at: aDN ifAbsentPut: [ LDAPEntryModel new name: aDN ].
	entry needSelfRefresh ifTrue: [ self searchSelf: aDN for: entry. ].
	entry needSubRefresh ifTrue: [ self searchSub: aDN for: entry. ].
	^ entry

]

{ #category : 'initialization' }
LDAPInspectorPresenter >> initializePresenters [ 

	cache := Dictionary new.
	customRoot := ''.
	dropRoot := self newDropList
		whenSelectionChangedDo: [ self rootChanged ];
		yourself.
	
	connection := self newButton
							label: 'Server';
				  			icon: (self iconNamed: #smallHome);
				     		help: 'Open te connection dialog';
				       	action: [ self openConnectionDialog ];
				        	yourself.
					
	miller := self instantiate: SpMillerPaginatorPresenter.
"	miller  
		withoutHorizontalScrollBar;
		visiblePages: 1;
		spacing: 5."
	miller millerListPresenter 
		presenterBlock: [ :aModel | self presenterFor: aModel value ];
		setRootModel: LDAPEntryModel new.
		 		
	statusBar := self newStatusBar.
	
	self updateRoots.

]

{ #category : 'initialization' }
LDAPInspectorPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter title: self titleForWindow.
	aSpWindowPresenter initialExtent: (600@480).
	aSpWindowPresenter whenClosedDo: [ application disconnect ].
]

{ #category : 'initialization' }
LDAPInspectorPresenter >> modelChanged [ 

	self updateRoots 
]

{ #category : 'searching' }
LDAPInspectorPresenter >> onSearchResult: aCommand for: anEntry [
	| responses |
	aCommand success ifFalse: [ ^ self ].
	responses := aCommand responses allButLast.
	
	anEntry populateFromResults: responses.
	anEntry changed.
]

{ #category : 'searching' }
LDAPInspectorPresenter >> onSearchSelf: aCommand for: anEntry [
	| response |
	aCommand success ifFalse: [ ^ self ].
	response := aCommand responses first.
	
	anEntry populateFromPartialAttributeList: response attributes.
	anEntry changed.
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> openConnectionDialog [
	
	| presenter |
	presenter := LDAPConnectionPresenter newApplication: application model: application session server.
	presenter onAccept: [ :sender | self connectionAccept: sender ].
	^ presenter openDialog
	
	
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> openCustomRootDialog [

	| dialog |
	dialog := application newRequest
		title: 'Custom Naming Context';
		label: 'Enter new root DN:';
		onAccept: [ :d | self customRoot: d presenter text ];
		onCancel: [ :d | dropRoot selectFirst ].
	^ dialog openDialog
]

{ #category : 'ui' }
LDAPInspectorPresenter >> presenterFor: anAttribute [

	| entry presenter |
	entry := self entryFor: anAttribute name.
	presenter := LDAPEntryPresenter newApplication: application model: entry.
	presenter activateOnSingleClick.
	^ presenter
]

{ #category : 'initialization' }
LDAPInspectorPresenter >> reset [

	miller millerListPresenter setRootModel: LDAPPartialAttributeList new.

]

{ #category : 'updating' }
LDAPInspectorPresenter >> rootChanged [

	| item root |
	"Last item is '...' and means user gets to choose a DN"
	(dropRoot selectedIndex = dropRoot listSize) ifTrue: [ ^ self openCustomRootDialog ].

	item := dropRoot selectedItem ifNil: [ ^ self ].
	item ifEmpty: [ ^ self ].
	(currentRoot = item) ifTrue: [ ^ self ].
	
	currentRoot := item.
	self clearCache.
	root := self entryFor: currentRoot.
	miller millerListPresenter setRootModel: root.
]

{ #category : 'searching' }
LDAPInspectorPresenter >> searchSelf: aDN for: anEntry [
"Search will return the base node for aDN"
	| request |
	application session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPBaseObjectScope new.

	application queue sendRequest: request onResultDo: [ :command | self onSearchSelf: command for: anEntry ].

]

{ #category : 'searching' }
LDAPInspectorPresenter >> searchSub: aDN for: anEntry [
"Search will return the child nodes of aDN"
	| request |
	application session connected ifFalse: [ ^ self ].
	
	request := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPSingleLevelScope new.

	application queue sendRequest: request onResultDo: [ :command | self onSearchResult: command for: anEntry ].

]

{ #category : 'updating' }
LDAPInspectorPresenter >> selectRoots [

	| roots |
	roots := self model roots asOrderedCollection.
	(roots indexOf: customRoot) isZero ifTrue: [ roots addLast: customRoot ]. 

	^ roots
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> titleForWindow [

	^ self className
]

{ #category : 'updating' }
LDAPInspectorPresenter >> updateRoots [

	| previousRoot roots newIndex |
	"Last item is '...' and means no selection"
	previousRoot := (dropRoot selectedIndex = dropRoot listSize) ifFalse: [ dropRoot selectedItem ].
	previousRoot isEmptyOrNil ifTrue: [ previousRoot := nil ].
	
	roots := self selectRoots.
	newIndex := (roots includes: previousRoot) ifFalse: [ 1 ] ifTrue: [ roots indexOf: previousRoot ].
	
	roots addLast: '...'.		
	dropRoot items: roots.
	dropRoot selectIndex: newIndex.
]
