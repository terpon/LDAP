"
I add a toolbar to the entry presenter
"
Class {
	#name : 'LDAPEntryEditorPresenter',
	#superclass : 'LDAPEntryPresenter',
	#instVars : [
		'toolBar',
		'deleteButton'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPEntryEditorPresenter class >> example [

	^ super example
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> addAction [

		UIManager inform: 'Add action'
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> connectPresenters [ 

	super connectPresenters.
	
	table whenSelectionChangedDo: [ :selection | self updateSelection: selection ].

]

{ #category : 'layout' }
LDAPEntryEditorPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: #name expand: false;
		add: #table;
		add: #toolBar expand: false;
		yourself
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> deleteAction [

	| model item |
	model := self model ifNil: [ ^self ].
	deleteButton isEnabled ifFalse: [ ^self ].
	item := table selectedItem.
	UIManager inform: 'Delete action on ', item name
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> editAction [

	UIManager inform: 'Edit action'
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	self initializeToolbar.
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializeToolbar [ 

	deleteButton := self newToolbarButton disable;
	            label: 'Delete';
		         icon: (self iconNamed: #smallDelete);
		         help: 'Delete current DN entry';
		         action: [ self deleteAction ];
		         yourself.
		
	toolBar := self newToolbar
			beIcons;
          addItemLeft: (self newToolbarButton 
		            label: 'New DN';
		            icon: (self iconNamed: #smallAdd);
		            help: 'Add a new sub entry to current DN';
		            action: [ self addAction ];
		            yourself);
           addItemLeft: deleteButton;
           addItemRight: (self newToolbarButton 
	            label: 'Edit';
		            icon: (self iconNamed: #editThiner);
		            help: 'Edit current DN attributes';
		            action: [ self editAction ];
		            yourself);
           yourself.
]

{ #category : 'events' }
LDAPEntryEditorPresenter >> updateSelection: aSelection [

	| model indices |
	deleteButton disable.
	model := self model ifNil: [ ^self ].
	
	indices := aSelection selectedIndexes.
	((indices size ~= 1) or: [ indices first > model branches size  ]) ifTrue: [ ^self ].
	
	deleteButton enable.
]
