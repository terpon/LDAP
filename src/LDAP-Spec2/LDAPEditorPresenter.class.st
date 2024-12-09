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
	elements := self lastAddedAttributes copyWith: LDAPLeafEntryAttribute new.
	aPresenter := LDAPNewEntryPresenter newApplication: application model: elements.

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
		  onAccept: [ application sendDeleteEntryRequest: aDN ];
		  onCancel: [ :d | d inform: 'Cancelled delete entry ' , aDN ];
		  openDialog.

]

{ #category : 'operations' }
LDAPEditorPresenter >> editEntry: aModel [

	| aPresenter aDialog elements aDN |
	elements := aModel leaves collect: #copy.
	aPresenter := LDAPEditEntryPresenter newApplication: application model: elements.

	aDN := aModel name.
	aPresenter name: aDN.
	aDialog := aPresenter openDialog
		okAction: [ :dialog | application sendModifyRequest: dialog presenter ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled edit entry for ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'callbacks' }
LDAPEditorPresenter >> invalidatePage: aDN [

	| page |
	page := miller pages detect: [ :p | p model name = aDN ] ifNone: [ ^self ].
	miller removeAllFrom: page.
]

{ #category : 'accessing' }
LDAPEditorPresenter >> lastAddedAttributes [

	^ lastAddedAttributes ifNil: [ 
			lastAddedAttributes := { LDAPLeafEntryAttribute new description: 'objectClass' } 
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

{ #category : 'dispatching' }
LDAPEditorPresenter >> sendAddEntryRequest: aPresenter [

	lastAddedAttributes := aPresenter filledAttributes.

	application sendAddEntryRequest: aPresenter.
]
