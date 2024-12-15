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

{ #category : 'accessing' }
LDAPEntryEditorPresenter class >> currentApplication [ 
	^ LDAPEditor new
]

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
		okAction: [ :dialog | | presenter |
			presenter := dialog presenter.
			application lastAddedAttributes: presenter filledAttributes.
			application sendAddEntry: presenter addRequest
		];
		cancelAction: [ :dialog | dialog inform: 'Cancelled add entry in ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> connectPresenters [ 

	super connectPresenters.
	
	toolBar addButton action: [ self addAction ].
	toolBar copyButton action: [ self copyAction ].
	toolBar deleteButton action: [ self deleteAction ].
	toolBar cutButton action: [ self cutAction ].
	toolBar pasteButton action: [ self pasteAction ].
	toolBar modifyButton action: [ self modifyAction ].
	toolBar editButton action: [ self editAction ].
	
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> copyAction [

	| aModel attributes aDN |
	aModel := self model ifNil: [ ^self ].
	aDN := aModel name.
	attributes := aModel leaves collect: #copy.

	application lastAddedAttributes: attributes.
	self inform: aDN, ' attributes saved as template'
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> cutAction [

	| aModel |
	aModel := self model ifNil: [ ^self ].

	application clipboardText: aModel name.
	self inform: aModel name, ' copied to clipboard'
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
		  onAccept: [ application sendDeleteEntry: aDN ];
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
		okAction: [ :dialog | application sendModify: dialog presenter modifyRequest ];
		cancelAction: [ :dialog | application inform: 'Cancelled edit entry for ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	
	toolBar := LDAPEntryToolbarPresenter newApplication: application owner: self.

]

{ #category : 'initialization' }
LDAPEntryEditorPresenter >> modelChanged [ 
	
	| model isLeaf |
	super modelChanged.
	
	toolBar deleteButton disable.
	model := self model ifNil: [ ^self ].
	isLeaf := model branches isEmpty.
	toolBar deleteButton enabled: isLeaf.


]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> modifyAction [

	| aModel aPresenter aDialog elements aDN |

	aModel := self model ifNil: [ ^self ].

	aDN := aModel name.
	elements := aModel leaves select: #isKey.

	aPresenter := LDAPModifyEntryPresenter newApplication: application model: elements.
	aPresenter parent: (LDAPName parentOf: aDN).

	aDialog := aPresenter openDialog
		okAction: [ :dialog | application sendModifyName: dialog presenter modifyRequest ];
		cancelAction: [ :dialog | application inform: 'Cancelled modify entry for ' , aDN ];
		yourself.
	^ aPresenter
]

{ #category : 'actions' }
LDAPEntryEditorPresenter >> pasteAction [

	| aModel aDN aRequest dialog |
	toolBar pasteButton isEnabled ifFalse: [ ^self ].
	aModel := self model ifNil: [ ^self ].

	aDN := application clipboardText.
	aDN isEmptyOrNil ifTrue: [ ^self ].
	aDN = aModel name ifTrue: [ ^self ].

	aRequest := LDAPModifyNameRequest new
		name: aDN;
		newRelativeName: (LDAPName firstName: aDN);
		underName: aModel name;
		yourself.

	dialog := SpConfirmDialog new
		  title: 'Confirm paste entry';
		  label: (String streamContents: [ :stream |
				stream nextPutAll: 'About to move '; nextPutAll: aDN; cr;
					nextPutAll: 'under '; nextPutAll: aModel name
			]);
		  acceptLabel: 'Move';
		  cancelLabel: 'Cancel';
		  onAccept: [ application sendModifyName: aRequest ];
		  onCancel: [ :d | application inform: 'Cancelled move entry ' , aDN ];
		  openDialog.
]
