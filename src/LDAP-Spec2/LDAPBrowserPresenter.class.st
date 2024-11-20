"
I am the main presenter of the LDAP browser.

Each level of the directory is on a page of the miller list.
"
Class {
	#name : 'LDAPBrowserPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roots',
		'dropRoot',
		'miller',
		'toolBar',
		'statusBar'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPBrowserPresenter class >> example [

	^ (self on: #('dc=example,dc=com') ) open

]

{ #category : 'layout' }
LDAPBrowserPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: #toolBar expand: false;
		add: #miller;
		add: #statusBar expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPBrowserPresenter >> initializePresenters [ 

	dropRoot := self newDropList
		whenSelectionChangedDo: [ self rootChanged ];
		yourself.
	toolBar := self newActionBar 
		           add: (self newButton
								label: 'Server';
				            icon: (self iconNamed: #smallHome);
				            help: 'Open te connection dialog';
				            action: [ toolBar inform: 'Ok' ];
				            yourself);
					centerPresenter: dropRoot;
		           yourself.
	miller := self instantiate: SpMillerPaginatorPresenter.
"	miller  
		withoutHorizontalScrollBar;
		visiblePages: 1;
		spacing: 5."
	miller millerListPresenter 
		presenterBlock: [ :aModel | self presenterFor: aModel ];
		setRootModel: LDAPPartialAttributeList new.
		 		
	statusBar := self newStatusBar.
]

{ #category : 'initialization' }
LDAPBrowserPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter title: self className.
	aSpWindowPresenter whenClosedDo: [ application session disconnect ].
]

{ #category : 'ui' }
LDAPBrowserPresenter >> presenterFor: aModel [

	^ LDAPEntryPresenter on: aModel 
]

{ #category : 'initialization' }
LDAPBrowserPresenter >> reset [

	miller setRootModel: LDAPPartialAttributeList new.

]

{ #category : 'ui' }
LDAPBrowserPresenter >> rootChanged [

	| item |
	item := dropRoot selectedItem ifNil: [ ^ self ].
	
]

{ #category : 'accessing - model' }
LDAPBrowserPresenter >> setModel: aModel [

	application session: aModel.
	self updatePresenter
	
]

{ #category : 'accessing - model' }
LDAPBrowserPresenter >> setModelBeforeInitialization: aModel [

	application session: aModel.
	
]

{ #category : 'initialization' }
LDAPBrowserPresenter >> updatePresenter [ 

	roots := application session roots.
	dropRoot items: roots, #('...').
	
	roots ifEmpty: [ self reset. ^ self ].
	
	dropRoot selectFirst.
]
