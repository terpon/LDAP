"
I am the main presenter of the LDAP browser.

Each level of the directory is on a page of the miller list.
"
Class {
	#name : 'LDAPInspectorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'dropRoot',
		'miller',
		'statusBar',
		'connection',
		'modelChanging'
	],
	#category : 'LDAP-Spec2-Entries',
	#package : 'LDAP-Spec2',
	#tag : 'Entries'
}

{ #category : 'accessing' }
LDAPInspectorPresenter class >> currentApplication [ 
	^ LDAPBrowser new
]

{ #category : 'ui' }
LDAPInspectorPresenter >> buildRootDropList: aCollection andSelect: anInteger [

	| state |
	dropRoot items: aCollection.
	dropRoot selectIndex: anInteger.
	state := aCollection isNotEmpty and: [ self model ifNil: [ false ] ifNotNil: [ :m | m connected.] ].
	dropRoot enabled: state.
]

{ #category : 'initialization' }
LDAPInspectorPresenter >> connectPresenters [ 

	super connectPresenters.
	
	statusBar onDisconnectDo: [ self application disconnect ].

]

{ #category : 'callbacks' }
LDAPInspectorPresenter >> connectionAccept: aServerInformation [
	| window |
	application connectTo: aServerInformation.
	
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
	
	dropRoot := self newDropList
	   display: [ :dn | dn ];
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
		presenterBlock: [ :aSelection | self presenterFor: aSelection value ];
		setRootModel: ''.
		 		
	statusBar := self instantiate: LDAPStatusBarPresenter.

]

{ #category : 'initialization' }
LDAPInspectorPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter title: self titleForWindow;
		initialExtent: (600@480);
		whenClosedDo: [ application disconnect ].
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

{ #category : 'factory' }
LDAPInspectorPresenter >> newEntryPresenterOn: anEntry [

	^ LDAPEntryPresenter newApplication: application model: anEntry
]

{ #category : 'simple dialog helpers' }
LDAPInspectorPresenter >> notify: aString [

	statusBar display: aString
]

{ #category : 'ui - dialogs' }
LDAPInspectorPresenter >> openConnectionDialog [
	
	| presenter |
	presenter := LDAPConnectionPresenter newApplication: application.
	presenter serverInformation: self model server.
	^ presenter openDialog
		okAction: [ :dialog | self connectionAccept: dialog presenter asServerInformation ];
		yourself
]

{ #category : 'ui' }
LDAPInspectorPresenter >> presenterFor: aString [

	| entry presenter |
	entry := application entryFor: aString.
	presenter := self newEntryPresenterOn: entry.
	^ presenter
]

{ #category : 'updating' }
LDAPInspectorPresenter >> rootChanged [

	| item |
	item := dropRoot selectedItem.
	item isEmptyOrNil ifTrue: [ ^ self ].
	
	self currentRoot: item.
]

{ #category : 'updating' }
LDAPInspectorPresenter >> selectRoots [

	| model |
	model := self model ifNil: [ ^ #() ].
	model server root ifNotEmpty: [ :rootDN | ^ { rootDN } ].
	^ model roots
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
	pages := miller pages ifEmpty: [ ^ self ].
	
	model := pages first model.
	root := application currentRoot.
	(root isNotEmpty and: [root = model name]) ifTrue: [
			"Force cache reload"
			pages do: [ :p | application entryFor: p model name ].
			^ self 
		].
	
	entry := application entryFor: root.
	miller millerListPresenter setRootModel: entry name.
	miller updatePaginator: 1.
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
