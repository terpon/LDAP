"
I add edit commands to the LDAP inspector
"
Class {
	#name : 'LDAPEditorPresenter',
	#superclass : 'LDAPInspectorPresenter',
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'operations' }
LDAPEditorPresenter >> addEntry: aModel [

	self inform: 'Add entry in ', aModel name
]

{ #category : 'operations' }
LDAPEditorPresenter >> deleteEntry: aModel [

	self inform: 'Delete entry ', aModel name
]

{ #category : 'operations' }
LDAPEditorPresenter >> editEntry: aModel [

	self inform: 'Edit entry ', aModel name
]

{ #category : 'factory' }
LDAPEditorPresenter >> newEntryPresenterOn: anEntry [

	| presenter |
	presenter := LDAPEntryEditorPresenter newApplication: application model: anEntry.
	presenter 
		onAdd: [ :model | self addEntry: model ];
		onDelete: [ :model | self deleteEntry: model ];
		onEdit: [ :model | self editEntry: model ].
	^ presenter
	
]
