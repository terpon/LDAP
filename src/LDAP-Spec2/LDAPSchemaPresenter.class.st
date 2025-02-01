"
I am a presenter to choose Object Classes when creating or editing entries
"
Class {
	#name : 'LDAPSchemaPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'schema',
		'list',
		'class'
	],
	#category : 'LDAP-Spec2-Schema',
	#package : 'LDAP-Spec2',
	#tag : 'Schema'
}

{ #category : 'examples' }
LDAPSchemaPresenter class >> example [

	^ (self on: LDAPSchema default) openDialog
]

{ #category : 'initialization' }
LDAPSchemaPresenter >> connectPresenters [

	list outputSelectionPort transmitTo: class inputModelPort.
]

{ #category : 'layout' }
LDAPSchemaPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
			add: list;
			add: class layout: #schemaLayout;
		yourself
]

{ #category : 'initialization' }
LDAPSchemaPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	 "Override OK button to add check"
	
	aDialogWindowPresenter
		addDefaultButton: 'Close' do: [ :presenter | 
			presenter triggerOkAction.
			presenter close ]
]

{ #category : 'initialization' }
LDAPSchemaPresenter >> initializePresenters [

	list := self newTable 
		alternateRowsColor;
		addColumn: (SpStringTableColumn new  
			title: 'Object Classes'; 
			evaluated: [ :each | each displayName ];
			beSortable;
			yourself);
		yourself.

	class := self instantiate: LDAPObjectClassPresenter.
]

{ #category : 'initialization' }
LDAPSchemaPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Object Classes';
		initialExtent: 550 @ 500
]

{ #category : 'initialization' }
LDAPSchemaPresenter >> modelChanged [ 

	| model |
	model := self model ifNil: [ LDAPSchema default ].
	list items: model structuralClasses sorted.
]
