"
I am the main presenter of the LDAP browser.

Each level of the directory is on a page of the miller list.
"
Class {
	#name : 'LDAPInspectorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'customRoot',
		'cache',
		'dropRoot',
		'miller',
		'statusBar',
		'connection',
		'rootDialog'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

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

{ #category : 'updating' }
LDAPInspectorPresenter >> currentRoot: aDN [

	| root |
	application currentRoot: aDN.
	root := application entryFor: aDN.
	miller millerListPresenter setRootModel: root.
]

{ #category : 'accessing' }
LDAPInspectorPresenter >> customRoot [

	^ customRoot ifNil: [ '' ] 
]

{ #category : 'accessing' }
LDAPInspectorPresenter >> customRoot: aString [

	customRoot := aString.
	self currentRoot: aString.
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

{ #category : 'initialization' }
LDAPInspectorPresenter >> initializePresenters [ 

	rootDialog := application newRequest
		title: 'Custom Naming Context';
		label: 'Enter new root DN:';
		onAccept: [ :d | self customRoot: d presenter text ];
		onCancel: [ :d | self updateRoots ].

	dropRoot := self newDropList
		whenSelectionChangedDo: [ self rootChanged ];
		yourself.
	
	connection := self newButton
				  			icon: (self iconNamed: #smallHome);
				     		help: 'Open the connection dialog';
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
	self model connected ifFalse: [ ^ self ].
	
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

	item := dropRoot selectedItem.
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

	^ self className
]

{ #category : 'updating' }
LDAPInspectorPresenter >> updateRoots [

	| roots newIndex |
	
	roots := self selectRoots.
	newIndex := roots indexOf: application currentRoot.
	
	"Always select something if there is a root"
	((newIndex = 0) and: [ roots isNotEmpty ]) ifTrue: [ newIndex := 1 ].
	
	roots addLast: '...'.		
	dropRoot items: roots.
	dropRoot selectIndex: newIndex.
]
