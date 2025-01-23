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

{ #category : 'accessing' }
LDAPEntryToolbarPresenter class >> currentApplication [ 
	^ LDAPEditor new
]

{ #category : 'examples' }
LDAPEntryToolbarPresenter class >> example [
	| model |
	model := LDAPEntryPresenter sampleEntry.
	^ (self on: model) open
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> addAction [

	entry ifNil: [ ^self ].
	new isEnabled ifFalse: [ ^self ].
	
	^ application openNewEntryDialogUnder: entry name with: #()
]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> clipboardChanged: anAnnouncement [

	self updatePaste: anAnnouncement content.
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
	
	application announcer when: LDAPClipboardChanged send: #clipboardChanged: to: self.
	application announcer when: LDAPIsConnected send: #updatePresenter to: self.
	application announcer when: LDAPIsDisconnected send: #disable to: self.
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> copyAction [

	entry ifNil: [ ^self ].
	copy isEnabled ifFalse: [ ^self ].
	
	application clipboardCopy: entry.
	self inform: entry name, ' attributes saved in clipboard'
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> cutAction [

	entry ifNil: [ ^self ].
	cut isEnabled ifFalse: [ ^self ].

	application clipboardCut: entry.
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
		  label: (Text fromString: 'About to delete '), (application formattedTextFor: aDN);
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
		help: 'Copy current entry attributes';
		yourself.
	cut := self newToolbarButton
		label: 'Cut';
		icon: (self iconNamed: #smallCut);
		help: 'Cut current entry name in clipboard';
		yourself.
	paste := self newToolbarButton
		label: 'Paste';
		icon: (self iconNamed: #smallPaste);
		help: 'Create or move clipboard entry under current entry';
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
		           addItemLeft: delete;
		           addItemLeft: copy;
		           addItemLeft: cut;
		           addItemLeft: paste;
		           addItemRight: edit;
		           addItemRight: modify;
		           yourself
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> modifyAction [

	| aPresenter aDN |
	entry ifNil: [ ^self ].
	modify isEnabled ifFalse: [ ^self ].

	aDN := entry name.
	aPresenter := LDAPModifyEntryPresenter newApplication: application model: aDN.

	^ aPresenter openDialog
		okAction: [ :dialog | application sendModifyName: dialog presenter modifyRequest ];
		cancelAction: [ :dialog | application inform: 'Cancelled modify entry for ' , aDN ];
		yourself
]

{ #category : 'actions' }
LDAPEntryToolbarPresenter >> pasteAction [

	| command |
	entry ifNil: [ ^self ].
	paste isEnabled ifFalse: [ ^self ].

	command := application clipboard.
	(command canBePastedAt: entry name) ifFalse: [ ^self ].
	
	^ command pasteAt: entry name in: application
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
LDAPEntryToolbarPresenter >> updatePaste: anObject [

	| current |
	paste disable.

	anObject ifNil: [ ^self ].
	current := entry ifNil: [ ^self ] ifNotNil: [ :e | e name ].
	(anObject canBePastedAt: current) ifFalse: [ ^self ].
	
	paste enable.
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

	self updatePaste: application clipboard.
	self updateDelete.
]
