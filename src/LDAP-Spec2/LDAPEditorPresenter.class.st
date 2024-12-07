"
I add edit commands to the LDAP inspector
"
Class {
	#name : 'LDAPEditorPresenter',
	#superclass : 'LDAPInspectorPresenter',
	#instVars : [
		'lastAddedAttributes'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'operations' }
LDAPEditorPresenter >> addEntry: aModel [

	| aPresenter aDialog elements aDN |
	elements := self lastAddedAttributes copyWith: LDAPAttributeElement new.
	aPresenter := LDAPAttributePresenter newApplication: application model: elements.

	aDN := aModel name.
	aPresenter parent: aDN.
	aDialog := aPresenter openDialog
		okAction: [ :dialog | self sendAddEntryRequest: dialog presenter ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled add entry in ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'operations' }
LDAPEditorPresenter >> deleteEntry: aModel [

	| dialog aDN |
	aDN := aModel name.
	dialog := SpConfirmDialog new
		  title: 'Confirm delete entry';
		  label: 'About to delete ', aDN;
		  acceptLabel: 'Delete';
		  cancelLabel: 'Cancel';
		  onAccept: [ self sendDeleteEntryRequest: aDN ];
		  onCancel: [ :d | d inform: 'Cancelled delete entry ' , aDN ];
		  openDialog.

]

{ #category : 'operations' }
LDAPEditorPresenter >> editEntry: aModel [

	self inform: 'Edit entry ', aModel name
]

{ #category : 'accessing' }
LDAPEditorPresenter >> lastAddedAttributes [

	^ lastAddedAttributes ifNil: [ 
			lastAddedAttributes := { LDAPAttributeElement new description: 'objectClass' } 
		]
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

{ #category : 'callbacks' }
LDAPEditorPresenter >> onAddedEntry: aDN [

	application invalidateParent: aDN.
]

{ #category : 'callbacks' }
LDAPEditorPresenter >> onDeletedEntry: aDN [

	| page |
	application invalidateParent: aDN.
	
	page := miller pages last.
	page model name = aDN ifFalse: [ ^self ].
	miller removeAllFrom: page.
]

{ #category : 'dispatching' }
LDAPEditorPresenter >> sendAddEntryRequest: aPresenter [

	| aRequest |
	lastAddedAttributes := aPresenter filledAttributes.

	aRequest := aPresenter addRequest.
	application sendRequest: aRequest 
		onSuccessDo: [ :command | self onAddedEntry: aRequest name ] 
		onFailureDo: [ :command | application reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditorPresenter >> sendDeleteEntryRequest: aDN [

	| aRequest |
	aRequest := LDAPDeleteRequest new name: aDN.

	application sendRequest: aRequest 
		onSuccessDo: [ :command | self onDeletedEntry: aDN ] 
		onFailureDo: [ :command | application reportError: command ]
]
