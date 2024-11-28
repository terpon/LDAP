"
I am the main presenter of the LDAP browser.

Each level of the directory is on a page of the miller list.
"
Class {
	#name : 'LDAPInspectorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'customRoot',
		'dropRoot',
		'miller',
		'statusBar',
		'connection',
		'rootDialog',
		'modelChanging'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'ui' }
LDAPInspectorPresenter >> buildRootDropList: aCollection andSelect: anInteger [

	| models |
	models := aCollection collect: [ :each | { each. nil } ].
	models addLast: { 'choose custom root DN…' . application iconNamed: #edit }.
	dropRoot items: models.
	dropRoot selectIndex: anInteger.
	dropRoot enabled: self model connected.
]

{ #category : 'initialization' }
LDAPInspectorPresenter >> connectPresenters [ 

	super connectPresenters.
	
	statusBar onDisconnectDo: [ self application disconnect ].

]

{ #category : 'callbacks' }
LDAPInspectorPresenter >> connectionAccept: aModel [
	| window |
	application connectTo: aModel copy.
	
	window := self window.
	window ifNil: [ self open ].
	window isClosed ifTrue: [ window open ].
]

{ #category : 'updating' }
LDAPInspectorPresenter >> currentRoot: aDN [

	(aDN = application currentRoot) ifTrue: [ ^ self ].

	"this will trigger a modelChanged"
	application currentRoot: aDN.

]

{ #category : 'accessing' }
LDAPInspectorPresenter >> customRoot [

	^ customRoot ifNil: [ '' ] 
]

{ #category : 'accessing' }
LDAPInspectorPresenter >> customRoot: aString [

	customRoot := aString.
	self currentRoot: aString.
]

{ #category : 'layout' }
LDAPInspectorPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight 
			add: connection expand: false;
			add: dropRoot;
			yourself) expand: false;
		add: miller;
		add: statusBar expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPInspectorPresenter >> initializePresenters [ 

	modelChanging := false.
	
	rootDialog := application newRequest
		title: 'Custom Naming Context';
		label: 'Enter new root DN:';
		onAccept: [ :d | self customRoot: d presenter text ];
		onCancel: [ :d | self updateRoots ].

	dropRoot := self newDropList
	   display: [ :model | model first ];
		displayIcon: [ :model | model second ];
		whenSelectionChangedDo: [ self rootChanged ];
		enabled: false;
		yourself.
	
	connection := self newToolbar beIcons;
				add: (self newToolbarButton 
							label: 'connection';
				  			icon: (self iconNamed: #smallHome);
				     		help: 'Open the connection dialog';
				       	action: [ self openConnectionDialog ];
				        	yourself); yourself.
					
	miller := self instantiate: SpMillerPaginatorPresenter.
	miller millerListPresenter 
		spacing: 5;
		presenterBlock: [ :aModel | self presenterFor: aModel value ];
		setRootModel: LDAPEntryModel new.
		 		
	statusBar := self instantiate: LDAPStatusBarPresenter.

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

	modelChanging := true.
	[ 
		self updateRoots.
		self updateMiller.
		self updateStatusBar.

		self withWindowDo: [ :aWindow | aWindow title: self titleForWindow ]
		
	] ensure: [ modelChanging := false ]
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> openConnectionDialog [
	
	| presenter |
	presenter := LDAPConnectionPresenter newApplication: application model: self model server copy.
	presenter onAccept: [ :model | self connectionAccept: model ].
	^ presenter openDialog
	
	
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> openCustomRootDialog [

	modelChanging ifTrue: [ ^ self ].
	
	self model connected ifFalse: [ ^ self ].
	self customRoot ifNotEmpty: [ :string | rootDialog text: string ].
	^ rootDialog openDialog
]

{ #category : 'ui' }
LDAPInspectorPresenter >> presenterFor: anAttribute [

	| entry presenter |
	entry := application entryFor: anAttribute name.
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

	| item |
	"Last item is '...' and means user gets to choose a DN"
	(dropRoot selectedIndex = dropRoot listSize) ifTrue: [ ^ self openCustomRootDialog ].

	item := dropRoot selectedItem ifNotNil: [ :i | i first ].
	item isEmptyOrNil ifTrue: [ ^ self ].
	
	self currentRoot: item.
]

{ #category : 'updating' }
LDAPInspectorPresenter >> selectRoots [

	| roots custom |
	roots := self model roots copy asOrderedCollection.
	custom := self customRoot.
	custom ifEmpty: [ ^ roots ].
	
	(roots indexOf: custom) isZero ifTrue: [ roots addLast: custom ]. 
	^ roots
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> titleForWindow [

	| session server url |
	session := self model ifNil: [ ^ self className ].
	server := session server.
	server hostname ifEmpty: [ ^ self className ].

	url := ZnUrl new scheme: server scheme; host: server hostname.
	server isPortDefault ifFalse: [ url port: server port ].
	session currentRoot isEmptyOrNil ifFalse: [ url addPathSegment: session currentRoot ].
		
	^ url printString
]

{ #category : 'updating' }
LDAPInspectorPresenter >> updateMiller [

	| pages model root entry |
	pages := miller millerListPresenter presenters.
	pages ifEmpty: [ ^ self ].
	
	model := pages first model.
	root := application currentRoot.
	(root = model name) ifTrue: [ ^ self ].
	
	entry := application entryFor: root.
	miller millerListPresenter setRootModel: entry
]

{ #category : 'updating' }
LDAPInspectorPresenter >> updateRoots [

	| roots newIndex |
	
	roots := self selectRoots.
	newIndex := roots indexOf: application currentRoot.
	
	"Always select something if there is a root"
	((newIndex = 0) and: [ roots isNotEmpty ]) ifTrue: [ newIndex := 1 ].
	
	self buildRootDropList: roots andSelect: newIndex
]

{ #category : 'updating' }
LDAPInspectorPresenter >> updateStatusBar [

	statusBar connected: self model connected.
]
