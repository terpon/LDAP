"
I add a toolbar to the entry presenter
"
Class {
	#name : 'LDAPEntryEditorPresenter',
	#superclass : 'LDAPEntryPresenter',
	#instVars : [
		'toolBar'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'layout' }
LDAPEntryEditorPresenter >> editorLayout [ 
	^ SpBoxLayout newTopToBottom
		add: #name expand: false;
		add: #toolBar expand: false;
		add: #table;
		yourself
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	self initializeToolbar.
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializeToolbar [ 

	toolBar := self newToolbar
			beIcons;
          addItem: (self newToolbarButton 
		            label: 'New DN';
		            icon: (self iconNamed: #smallAdd);
		            help: 'Add a new sub entry to current DN';
		            action: [ self addAction ];
		            yourself);
           addItem: (self newToolbarButton 
	            label: 'Delete';
		            icon: (self iconNamed: #smallCancel);
		            help: 'Delete current DN entry';
		            action: [ self deleteAction ];
		            yourself);
           yourself.
]
