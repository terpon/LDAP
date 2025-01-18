"
I am the main presenter of the Server Bookmarks application
"
Class {
	#name : 'LDAPBookmarkEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'bookmarks',
		'commitAction',
		'list',
		'serverInfo',
		'name',
		'toolbar',
		'actions'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'accessing' }
LDAPBookmarkEditor class >> currentApplication [ 

	^ LDAPBookmarks new
]

{ #category : 'examples' }
LDAPBookmarkEditor class >> example [
	| example |
	example := self new onBookmarksChangeDo: [ :b | b inspect ].
	example open;
		withWindowDo: [ :window | window title: self name asString , ' example' ].
	^ example
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> addEntry [

	| anAssociation |
	anAssociation := name text -> serverInfo asServerInformation.
	self bookmarks addLast: anAssociation.
	self commit.
	self updatePresenter.
	self selectIndex: bookmarks size.
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> bookmarks [

	^ bookmarks ifNil: [ bookmarks := OrderedCollection new ]
]

{ #category : 'private - drag and drop' }
LDAPBookmarkEditor >> checkDrop: aTransfer [

	| anAssociation |
	aTransfer passenger isCollection ifFalse: [ ^false ].
	anAssociation := aTransfer passenger first.
	"Only accept if correct type"
	anAssociation isAssociation ifFalse: [ ^ false ].
	anAssociation key isString ifFalse: [ ^ false ].
	^ anAssociation value isKindOf: LDAPServerInformation
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> commit [

	commitAction ifNotNil: [ :block | block cull: self bookmarks ]
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> confirmSavePassword: aContinuationBlock [

	serverInfo password ifEmpty: [ ^ aContinuationBlock value ].
	^ SpConfirmDialog new
		  title: 'Entry password is set';
		  label: 'Are you sure to save the password?';
		  acceptLabel: 'Save';
		  onAccept: [ aContinuationBlock value ];
		  openDialog
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> connectPresenters [ 

	super connectPresenters.
	toolbar saveButton action: [ self saveCurrent ].
	toolbar deleteButton action: [ self deleteCurrent ].
	list whenSelectionChangedDo: [ :selection | self updateCurrent ].
]

{ #category : 'layout' }
LDAPBookmarkEditor >> defaultLayout [

	| entries bookmark |
	entries := SpBoxLayout newTopToBottom
		add: list;
		yourself.

	bookmark := SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter; add: 'Name: ' expand: false; 
			add: name; yourself) expand: false;
		add: serverInfo;
		add: toolbar expand: false;
		yourself.
		
	^ SpPanedLayout newLeftToRight
			add: entries;
			add: bookmark;
			positionOfSlider: 0.3;
			yourself
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> deleteCurrent [

	| association label |
	association := self selectedItem ifNil: [ ^self ].
	label := String streamContents: [ :out |
		out nextPutAll: 'About to delete ';
			nextPutAll: association key.
	].
	^ SpConfirmDialog new
		  title: 'Confirm Entry Deletion';
		  label: label;
		  acceptLabel: 'Delete';
		  onAccept: [ self deleteEntry: association ];
		  openDialog
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> deleteEntry: anAssociation [

	| anIndex |
	anIndex := bookmarks identityIndexOf: anAssociation ifAbsent: [ ^self ]. 
	bookmarks removeAt: anIndex.
	self commit.
	self selectIndex: 0.
	self updatePresenter.
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializeActions [ 

	actions := (SpActionGroup newName: 'Connect')
		addActionWith: [ :anItem | anItem
			name: 'Open Browser';
			description: 'open a LDAP browser';
			actionEnabled: [ self isCurrentValid ];
			action: [ self open: LDAPBrowser ] ];
		addActionWith: [ :anItem | anItem
			name: 'Open Editor';
			description: 'open a LDAP editor';
			actionEnabled: [ self isCurrentValid ];
			action: [ self open: LDAPEditor ] ].
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializeList [

	list := (self instantiate: SpFilteringListPresenter)
		display: [ :each | each key ];
		headerTitle: 'Bookmarks'; 
		yourself.
		
	list listPresenter actions: actions;
		dropEnabled: true;
		wantsDrop: [ :aTransfer | self checkDrop: aTransfer ];
		acceptDrop: [ :aTransfer | self moveEntry: aTransfer ];
		whenActivatedDo: [ :aSelection | self inform: aSelection selectedItem key ];
		dragEnabled: true;
		whenDragStartDo: [ :ann | | anEntry |
			anEntry := ann transfer passenger first.
			ann transfer description: ('Moving "{1}" entry' format: {anEntry key}).
		].
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializePresenters [ 

	self initializeActions.
	self initializeList.
	serverInfo := (self instantiate: LDAPConnectionPresenter).
	name := self newTextInput placeholder: 'Friendly name of the server connection info'.
	toolbar := (self instantiate: LDAPBookmarksToolbarPresenter) connectActions: actions.
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'LDAP Saved Connections';
		initialExtent: 700 @ 500
]

{ #category : 'testing' }
LDAPBookmarkEditor >> isCurrentValid [

	^ serverInfo hostname isNotEmpty
]

{ #category : 'private - drag and drop' }
LDAPBookmarkEditor >> moveEntry: aTransfer [

	| anAssociation anItem anIndex |
	anAssociation := aTransfer passenger first.

	"The index is in the filtered list"
	anItem := aTransfer index isZero ifFalse: [ list listPresenter items at: aTransfer index ].
	anItem == anAssociation ifTrue: [ ^self ].
	
	anIndex := bookmarks identityIndexOf: anAssociation.
	anIndex isZero ifFalse: [ bookmarks removeAt: anIndex ] 
		ifTrue: [ "not from this list, copy the data"
			anAssociation := anAssociation deepCopy.
		]. 
	
	anItem ifNil: [ bookmarks addLast: anAssociation ]
		ifNotNil: [ 
			anIndex := bookmarks identityIndexOf: anItem.
			bookmarks add: anAssociation beforeIndex: anIndex.
		].

	self commit.
	self updatePresenter.
]

{ #category : 'enumerating' }
LDAPBookmarkEditor >> onBookmarksChangeDo: aBlock [

	commitAction := aBlock
]

{ #category : 'ui requests' }
LDAPBookmarkEditor >> open: aClass [

	| aServer |
	aServer := serverInfo asServerInformation.
	aServer hostname ifEmpty: [ ^self inform: 'No hostname defined' ].
	aServer password ifNotEmpty: [ ^application open: aClass on: aServer ].

	^ SpRequestDialog new "bePassword;"
		title: 'Enter Password for';
		label: aServer asZnUrl printString;
		text: aServer password;
		onAccept: [ :dialog | 
			aServer password: dialog presenter text.
			application open: aClass on: aServer.
		];
		openDialog
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> replaceEntry: anAssociation [

	anAssociation value: serverInfo asServerInformation.
	self commit.
]

{ #category : 'updating - presenters' }
LDAPBookmarkEditor >> reset [

	name text: ''.
	serverInfo setModel: LDAPServerInformation new.

]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> saveCurrent [

	| key block |
	key := name text.
	key ifEmpty: [ ^self inform: 'Entry has no name' ].
	
	block := self bookmarks detect: [ :b | b key = key ] 
		ifFound: [ :association |  [ self replaceEntry: association ] ] 
		ifNone: [ [ self addEntry ] ].
		
	self confirmSavePassword: block.
]

{ #category : 'accessing' }
LDAPBookmarkEditor >> selectIndex: anInteger [

	list listPresenter selectIndex: anInteger.

]

{ #category : 'accessing' }
LDAPBookmarkEditor >> selectedIndex [

	^ list listPresenter selection selectedIndex
]

{ #category : 'accessing' }
LDAPBookmarkEditor >> selectedItem [

	^ list selectedItem
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> setModel: aDomainObject [

	self setModelBeforeInitialization: aDomainObject.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> setModelBeforeInitialization: aDomainObject [

	bookmarks := aDomainObject asOrderedCollection.
]

{ #category : 'updating - presenters' }
LDAPBookmarkEditor >> updateCurrent [

	| association |
	association := self selectedItem ifNil: [ ^self reset ].
	name text: association key.
	serverInfo serverInformation: association value copy.

]

{ #category : 'initialization' }
LDAPBookmarkEditor >> updatePresenter [

	list items: self bookmarks.
	self updateCurrent.
]
