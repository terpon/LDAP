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
		'save',
		'delete',
		'connect'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'examples' }
LDAPBookmarkEditor class >> example [

	<sampleInstance>
	| example |
	example := self new onBookmarksChangeDo: [ :b | b inspect ].
	example open;
		withWindowDo: [ :window | window title: self name asString , ' example' ].
	^ example
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> addEntry [

	| anAssociation |
	anAssociation := name text -> serverInfo serverInfo copy.
	self bookmarks addLast: anAssociation.
	self commit.
	list items: bookmarks.
	list listPresenter selectIndex: bookmarks size.
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> bookmarks [

	^ bookmarks ifNil: [ bookmarks := OrderedCollection new ]
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> commit [

	commitAction ifNotNil: [ :block | block cull: self bookmarks ]
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> confirmSavePassword: aContinuationBlock [

	serverInfo serverInfo password ifEmpty: [ ^ aContinuationBlock value ].
	^ SpConfirmDialog new
		  title: 'Entry password is set';
		  label: 'Are you sure to save the password?';
		  acceptLabel: 'Save';
		  onAccept: [ aContinuationBlock value ];
		  openDialog
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> connectCurrent [

	serverInfo serverInfo hostname ifEmpty: [ ^self inform: 'No hostname defined' ].
	application newBrowser: serverInfo serverInfo copy.
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> connectPresenters [ 

	super connectPresenters.
	save action: [ self saveCurrent ].
	delete action: [ self deleteCurrent ].
	connect action: [ self connectCurrent ].
	
	list whenSelectionChangedDo: [ :selection | self updateCurrent ].

]

{ #category : 'layout' }
LDAPBookmarkEditor >> defaultLayout [

	| entries buttons bookmark |
	entries := SpBoxLayout newTopToBottom
		add: list;
		yourself.

	buttons := SpBoxLayout newLeftToRight 
		add:  (SpBoxLayout newLeftToRight spacing: 5;
			add: save expand: false;
			add: delete expand: false;
			yourself);
		add: (SpBoxLayout newLeftToRight hAlignEnd;
			add: connect expand: false;
			yourself); 
		yourself.
	
	bookmark := SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter; add: 'Name: ' expand: false; 
			add: name; yourself) expand: false;
		add: serverInfo;
		add: buttons expand: false;
		yourself.
		
	^ SpPanedLayout newLeftToRight
			add: entries;
			add: bookmark;
			positionOfSlider: 0.3;
			yourself
]

{ #category : 'callbacks' }
LDAPBookmarkEditor >> deleteCurrent [

	| index association label |
	association := self selectedItem ifNil: [ ^self ].
	index := self selectedIndex.
	label := String streamContents: [ :out |
		out nextPutAll: 'About to delete ';
			nextPutAll: association key.
	].
	^ SpConfirmDialog new
		  title: 'Confirm Entry Deletion';
		  label: label;
		  acceptLabel: 'Delete';
		  onAccept: [ bookmarks removeAt: index. self commit ];
		  openDialog
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> deleteEntry [

	| index |
	index := self selectedIndex.
	bookmarks removeAt: index.
	self commit.
	list items: bookmarks.
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializePresenters [ 

	list := (self instantiate: SpFilteringListPresenter)
		display: [ :each | each key ];
		headerTitle: 'Bookmarks'; 
		yourself.
	serverInfo := (self instantiate: LDAPConnectionPresenter).
	name := self newTextInput placeholder: 'Friendly name of the server connection info'.
	save := self newButton 
		label: 'Save'; icon: (self iconNamed: #smallSave);
		help: 'Save or Replace the entry to the preference file';
		action: [ self saveCurrent ].
	delete := self newButton
		label: 'Delete'; icon: (self iconNamed: #smallDelete);
		help: 'Delete current entry from the preference file';
		action: [ self deleteCurrent ].
	connect := self newButton
		label: 'Connect';
		help: 'Open a browser window with current server information'.
]

{ #category : 'initialization' }
LDAPBookmarkEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'LDAP Saved Connections';
		initialExtent: 700 @ 500
]

{ #category : 'enumerating' }
LDAPBookmarkEditor >> onBookmarksChangeDo: aBlock [

	commitAction := aBlock
]

{ #category : 'accessing - model' }
LDAPBookmarkEditor >> replaceEntry: anAssociation [

	| index |
	index := list listPresenter selection selectedIndex.
	anAssociation value: serverInfo serverInfo copy.
	self commit.
]

{ #category : 'updating - presenters' }
LDAPBookmarkEditor >> reset [

	name text: ''.
	serverInfo setModel: LDAPServerInfo new.

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
	serverInfo setModel: association value copy.

]

{ #category : 'initialization' }
LDAPBookmarkEditor >> updatePresenter [

	list items: self bookmarks.
	self updateCurrent.
]
