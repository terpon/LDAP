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
	example := self new whenBookmarksChangeDo: [ :b | b inspect ].
	example open;
		withWindowDo: [ :window | window title: self name asString , ' example' ].
	^ example
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

{ #category : 'initialization' }
LDAPBookmarkEditor >> reset [

	name text: ''.
	serverInfo setModel: LDAPServerInformation new.

]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> saveCurrent [

	| anAssociation |
	name text ifEmpty: [ ^self inform: 'Entry has no name' ].
	anAssociation := name text -> serverInfo asServerInformation.
	
	serverInfo password ifEmpty: [ ^self saveEntry: anAssociation ].
	^ LDAPConfirmSavePasswordDialog new
		  onAccept: [ self saveEntry: anAssociation ];
		  onClear: [ anAssociation value password: ''. self saveEntry: anAssociation ];
		  openDialog
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> saveEntry: anAssociation [
	
	| anEntry |
	anEntry := self bookmarks detect: [ :b | b key = anAssociation key ] 
		ifFound: [ :association | association value: anAssociation value. association ] 
		ifNone: [ self bookmarks addLast: anAssociation ].

	self commit.
	self updatePresenter.
	self selectItem: anEntry.
]

{ #category : 'api - selection' }
LDAPBookmarkEditor >> selectItem: anObject [

	| aListPresenter anInteger |
	aListPresenter := list listPresenter.
	anInteger := aListPresenter items identityIndexOf: [ anObject ].
	aListPresenter selectIndex: anInteger.

]

{ #category : 'api - selection' }
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

	| anAssociation |
	anAssociation := self selectedItem ifNil: [ ^self reset ].
	name text: anAssociation key.
	serverInfo serverInformation: anAssociation value.

]

{ #category : 'initialization' }
LDAPBookmarkEditor >> updatePresenter [

	list items: self bookmarks.
	self updateCurrent.
]

{ #category : 'api - events' }
LDAPBookmarkEditor >> whenBookmarksChangeDo: aBlock [

	commitAction := aBlock
]
