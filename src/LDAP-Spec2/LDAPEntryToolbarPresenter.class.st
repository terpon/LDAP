"
I am the toolbar with buttons to edit a directory entry
"
Class {
	#name : 'LDAPEntryToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
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
LDAPEntryToolbarPresenter >> addButton [
	^ new
]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> clipboardCleared [

	paste disable;
			help: 'Paste saved entry under current entry'.

	"Does not update help with morphic"	
	paste withAdapterDo: [ :anAdapter | anAdapter setBalloonText: paste help ]

]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> clipboardSet: anAnnouncement [

	| dn |
	dn := anAnnouncement text.
	paste enable;
			help: 'Move saved entry under current entry', String cr, dn.

	"Does not update help with morphic"	
	paste withAdapterDo: [ :anAdapter | anAdapter setBalloonText: paste help ]

]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> connectPresenters [ 

	super connectPresenters.
	
	application when: LDAPClipboardCleared send: #clipboardCleared to: self.
	application when: LDAPClipboardChanged send: #clipboardSet: to: self.
	
	self reset.

]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> copyButton [
	^ copy
]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> cutButton [
	^ cut
]

{ #category : 'layout' }
LDAPEntryToolbarPresenter >> defaultLayout [ 
	^ SpBoxLayout newLeftToRight 
		add: toolBar;
		yourself
]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> deleteButton [
	^ delete
]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> editButton [
	^ edit
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

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> modifyButton [
	^ modify
]

{ #category : 'accessing' }
LDAPEntryToolbarPresenter >> pasteButton [
	^ paste
]

{ #category : 'initialization' }
LDAPEntryToolbarPresenter >> reset [ 

	delete disable.
	application clipboardText 
		ifNotNil: [ :text | self clipboardSet: (LDAPClipboardChanged new text: text) ] 
		ifNil: [ self clipboardCleared ] 
]
