"
I am the toolbar with buttons to edit a directory entry
"
Class {
	#name : 'LDAPEntryToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'entry',
		'toolBar',
		'new',
		'delete',
		'copy',
		'cut',
		'paste',
		'modify',
		'edit'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> addAction [

	| aPresenter elements aDN |
	entry ifNil: [ ^self ].
	new isEnabled ifFalse: [ ^self ].
	
	aDN := entry name.
	elements := application lastAddedAttributes copyWith: LDAPLeafEntryAttribute new.

	aPresenter := LDAPNewEntryPresenter newApplication: application model: elements.
	aPresenter parent: aDN.

	^ aPresenter openDialog
		okAction: [ :dialog | | presenter |
			presenter := dialog presenter.
			application lastAddedAttributes: presenter filledAttributes.
			application sendAddEntry: presenter addRequest
		];
		cancelAction: [ :dialog | dialog inform: 'Cancelled add entry in ' , aDN ];
		yourself
]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> clipboardChanged: anAnnouncement [

	self updatePaste: anAnnouncement text.
]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> connectPresenters [ 

	super connectPresenters.
	new action: [ self addAction ].
	copy action: [ self copyAction ].
	delete action: [ self deleteAction ].
	cut action: [ self cutAction ].
	paste action: [ self pasteAction ].
	modify action: [ self modifyAction ].
	edit action: [ self editAction ].
	
	application when: LDAPClipboardChanged send: #clipboardChanged: to: self.
	application when: LDAPIsConnected send: #updatePresenter to: self.
	application when: LDAPIsDisconnected send: #disable to: self.
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> copyAction [

	| attributes aDN |
	entry ifNil: [ ^self ].
	copy isEnabled ifFalse: [ ^self ].
	
	aDN := entry name.
	attributes := entry leaves collect: #copy.

	application lastAddedAttributes: attributes.
	self inform: aDN, ' attributes saved as template'
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> cutAction [

	entry ifNil: [ ^self ].
	cut isEnabled ifFalse: [ ^self ].

	application clipboardText: entry name.
	self inform: entry name, ' copied to clipboard'
]

{ #category : 'layout' }
LDAPEntryToolbarPresenter >> defaultLayout [ 
	^ SpBoxLayout newLeftToRight 
		add: toolBar;
		yourself
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> deleteAction [

	| aDN |
	entry ifNil: [ ^self ].
	delete isEnabled ifFalse: [ ^self ].

	aDN := entry name.
	^ SpConfirmDialog new
		  title: 'Confirm delete entry';
		  label: 'About to delete ', aDN;
		  acceptLabel: 'Delete';
		  cancelLabel: 'Cancel';
		  onAccept: [ application sendDeleteEntry: aDN ];
		  onCancel: [ :d | application inform: 'Cancelled delete entry ' , aDN ];
		  openDialog
]

{ #category : 'api' }
LDAPEntryToolbarPresenter >> disable [

	new disable.
	copy disable.
	cut disable.
	paste disable.
	delete disable.
	modify disable.
	edit disable.
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> editAction [

	| aPresenter elements aDN |
	entry ifNil: [ ^self ].
	edit isEnabled ifFalse: [ ^self ].

	aDN := entry name.
	elements := entry leaves collect: #copy.

	aPresenter := LDAPEditEntryPresenter newApplication: application model: elements.
	aPresenter name: aDN.

	^ aPresenter openDialog
		okAction: [ :dialog | application sendModify: dialog presenter modifyRequest ];
		cancelAction: [ :dialog | application inform: 'Cancelled edit entry for ' , aDN ];
		yourself
]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> entry: anObject [

	entry := anObject.
	self updatePresenter.
]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> initializePresenters [

	new := self newToolbarButton
		label: 'New entry';
		icon: (self iconNamed: #smallAdd);
		help: 'Add a new entry under current entry';
		yourself.
	copy := self newToolbarButton
		label: 'Copy';
		icon: (self iconNamed: #smallCopy);
		help: 'Save current entry attributes as template for new entries';
		yourself.
	cut := self newToolbarButton
		label: 'Cut';
		icon: (self iconNamed: #smallCut);
		help: 'Cut current entry and all chidren';
		yourself.
	paste := self newToolbarButton
		label: 'Paste';
		icon: (self iconNamed: #smallPaste);
		yourself.
	delete := self newToolbarButton
		label: 'Delete';
		icon: (self iconNamed: #smallDelete);
		help: 'Delete current entry';
		yourself.
	modify := self newToolbarButton
		label: 'Modify';
		icon: (self iconNamed: #branch);
		help: 'Change current entry relative DN';
		yourself.
	edit := self newToolbarButton
		label: 'Edit';
		icon: (self iconNamed: #editThiner);
		help: 'Edit current DN attributes';
		yourself.
	toolBar := self newToolbar
		           beIcons;
		           addItemLeft: new;
		           addItemLeft: copy;
		           addItemLeft: delete;
		           addItemLeft: cut;
		           addItemLeft: paste;
		           addItemRight: edit;
		           addItemRight: modify;
		           yourself
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> modifyAction [

	| aPresenter elements aDN |
	entry ifNil: [ ^self ].
	modify isEnabled ifFalse: [ ^self ].

	aDN := entry name.
	elements := entry leaves select: #isKey.

	aPresenter := LDAPModifyEntryPresenter newApplication: application model: elements.
	aPresenter parent: (LDAPName parentOf: aDN).

	^ aPresenter openDialog
		okAction: [ :dialog | application sendModifyName: dialog presenter modifyRequest ];
		cancelAction: [ :dialog | application inform: 'Cancelled modify entry for ' , aDN ];
		yourself
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> pasteAction [

	| underDN aDN aRequest |
	entry ifNil: [ ^self ].
	paste isEnabled ifFalse: [ ^self ].

	aDN := application clipboardText.
	aDN isEmptyOrNil ifTrue: [ ^self ].
	(aDN = entry name) ifTrue: [ ^self ].

	underDN := entry name.
	aRequest := LDAPModifyNameRequest new
		name: aDN;
		newRelativeName: (LDAPName firstName: aDN);
		underName: underDN;
		yourself.

	^ SpConfirmDialog new
		  title: 'Confirm paste entry';
		  label: (String streamContents: [ :stream |
				stream nextPutAll: 'About to move '; nextPutAll: aDN; cr;
					nextPutAll: 'under '; nextPutAll: underDN
			]);
		  acceptLabel: 'Move';
		  cancelLabel: 'Cancel';
		  onAccept: [ application sendModifyName: aRequest ];
		  onCancel: [ :d | application inform: 'Cancelled move entry ' , aDN ];
		  openDialog
]

{ #category : 'accessing - model' }
LDAPEntryToolbarPresenter >> setModel: anObject [

	self entry: anObject
]

{ #category : 'accessing - model' }
LDAPEntryToolbarPresenter >> setModelBeforeInitialization: anObject [

	entry := anObject
]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> updateDelete [

	| isLeaf |
	isLeaf := entry ifNil: [ false ] ifNotNil: [ :e | e branches isEmpty ].
	delete enabled: isLeaf.

]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> updatePaste: dn [

	| current |
	paste disable.
	paste help: 'Move saved entry under current entry'.
	paste withAdapterDo: [ :anAdapter | anAdapter setBalloonText: paste help ].

	dn isEmptyOrNil ifTrue: [ ^self ].
	current := entry ifNil: [ ^self ] ifNotNil: [ :e | e name ].
	(LDAPName is: current under: dn) ifTrue: [ ^self ].
	
	paste enable.
	paste help: 'Move saved entry under current entry', String cr, dn.
	"Does not update help with morphic"	
	paste withAdapterDo: [ :anAdapter | anAdapter setBalloonText: paste help ]

]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> updatePresenter [

	entry ifNil: [ ^ self disable ].
	application isConnected ifFalse: [ ^ self disable ].
	
	new enable.
	copy enable.
	cut enable.
	modify enable.
	edit enable.	

	self updatePaste: application clipboardText.
	self updateDelete.
]
