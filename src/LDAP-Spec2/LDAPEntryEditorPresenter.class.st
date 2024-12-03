"
I add a toolbar to the entry presenter
"
Class {
	#name : 'LDAPEntryEditorPresenter',
	#superclass : 'LDAPEntryPresenter',
	#instVars : [
		'toolBar',
		'deleteButton',
		'onAdd',
		'onDelete',
		'onEdit'
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

	| model |
	model := self model ifNil: [ ^self ].
	application connected ifFalse: [ ^ self ].
	
	onAdd ifNotNil: [ :action | action cull: model ].
	UIManager inform: 'Add action'.

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
	deleteButton isEnabled ifFalse: [ ^self ].
	model := self model ifNil: [ ^self ].
	application connected ifFalse: [ ^ self ].

	onDelete ifNotNil: [ :action | action cull: model ].
	UIManager inform: 'Delete action on ', model name
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> editAction [

	| model |
	model := self model ifNil: [ ^self ].
	onEdit ifNotNil: [ :action | action cull: model ].
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

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> modelChanged [ 

	| model |
	deleteButton disable.
	super modelChanged.
	
	model := self model ifNil: [ ^self ].
	deleteButton enabled: model branches isEmpty.
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onAdd [

	^ onAdd
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onAdd: aBlock [

	onAdd := aBlock
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onDelete [

	^ onDelete
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onDelete: aBlock [

	onDelete := aBlock
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onEdit [

	^ onEdit
]

{ #category : 'accessing' }
LDAPEntryEditorPresenter >> onEdit: aBlock [

	onEdit := aBlock
]
