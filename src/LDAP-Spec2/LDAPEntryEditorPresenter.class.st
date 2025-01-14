"
I add a toolbar to the entry presenter
"
Class {
	#name : 'LDAPEntryEditorPresenter',
	#superclass : 'LDAPEntryPresenter',
	#instVars : [
		'toolBar'
	],
	#category : 'LDAP-Spec2-Entries',
	#package : 'LDAP-Spec2',
	#tag : 'Entries'
}

{ #category : 'accessing' }
LDAPEntryEditorPresenter class >> currentApplication [ 
	^ LDAPEditor new
]

{ #category : 'examples' }
LDAPEntryEditorPresenter class >> example [

	^ super example
]

{ #category : 'layout' }
LDAPEntryEditorPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: #name expand: false;
		add: #table;
		add: #toolBar expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	
	toolBar := LDAPEntryToolbarPresenter newApplication: application owner: self model: self model.

]

{ #category : 'transmission' }
LDAPEntryEditorPresenter >> setModel: aModel [ 
	
	super setModel: aModel.
	toolBar entry: aModel.
	
]

{ #category : 'updating' }
LDAPEntryEditorPresenter >> updatePresenter [ 

	super updatePresenter.
	
	toolBar entry: self model.
	
]
