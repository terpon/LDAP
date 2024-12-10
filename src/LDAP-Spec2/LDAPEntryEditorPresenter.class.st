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

{ #category : 'examples' }
LDAPEntryEditorPresenter class >> example [

	^ super example
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> addAction [

	| aModel aPresenter aDialog elements aDN |
	aModel := self model ifNil: [ ^self ].
	application connected ifFalse: [ ^ self ].
	
	elements := application lastAddedAttributes copyWith: LDAPLeafEntryAttribute new.
	aPresenter := LDAPNewEntryPresenter newApplication: application model: elements.

	aDN := aModel name.
	aPresenter parent: aDN.
	aDialog := aPresenter openDialog
		okAction: [ :dialog | application sendAddEntryRequest: dialog presenter ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled add entry in ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> connectPresenters [ 

	super connectPresenters.
	
	toolBar addButton action: [ self addAction ].
	toolBar deleteButton action: [ self deleteAction ].
	toolBar copyButton action: [  ].
	toolBar cutButton action: [  ].
	toolBar pasteButton action: [  ].
	toolBar modifyButton action: [ self modifyAction ].
	toolBar editButton action: [ self editAction ].
	
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

	| model dialog aDN |
	toolBar deleteButton isEnabled ifFalse: [ ^self ].
	model := self model ifNil: [ ^self ].
	application connected ifFalse: [ ^ self ].

	aDN := model name.
	dialog := SpConfirmDialog new
		  title: 'Confirm delete entry';
		  label: 'About to delete ', aDN;
		  acceptLabel: 'Delete';
		  cancelLabel: 'Cancel';
		  onAccept: [ application sendDeleteEntryRequest: aDN ];
		  onCancel: [ :d | application inform: 'Cancelled delete entry ' , aDN ];
		  openDialog.

]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> editAction [

	| aModel aPresenter aDialog elements aDN |

	aModel := self model ifNil: [ ^self ].
	elements := aModel leaves collect: #copy.
	aPresenter := LDAPEditEntryPresenter newApplication: application model: elements.

	aDN := aModel name.
	aPresenter name: aDN.
	aDialog := aPresenter openDialog
		okAction: [ :dialog | application sendModifyRequest: dialog presenter ];
		cancelAction: [ :dialog | application inform: 'Cancelled edit entry for ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	
	toolBar := self instantiate: LDAPEntryToolbarPresenter.

]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> modelChanged [ 

	super modelChanged.
	
	toolBar update: self model.

]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> modifyAction [

	| aModel aPresenter aDialog elements aDN |

	aModel := self model ifNil: [ ^self ].

	aDN := aModel name.
	elements := (LDAPName firstAsPairs: aDN) collect: [ :pair | LDAPLeafEntryAttribute newFromPair: pair ].

	aPresenter := LDAPModifyEntryPresenter newApplication: application model: elements.
	aPresenter parent: (LDAPName parentOf: aDN).

	aDialog := aPresenter openDialog
		okAction: [ :dialog | application sendModifyNameRequest: dialog presenter ];
		cancelAction: [ :dialog | application inform: 'Cancelled modify entry for ' , aDN ];
		yourself.
	^ aPresenter
]
