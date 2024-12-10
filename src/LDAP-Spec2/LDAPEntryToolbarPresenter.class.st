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
		label: 'New DN';
		icon: (self iconNamed: #smallAdd);
		help: 'Add a new sub entry to current DN';
		yourself.
	copy := self newToolbarButton
		label: 'Copy';
		icon: (self iconNamed: #smallCopy);
		help: 'Copy current entry';
		yourself.
	cut := self newToolbarButton disable;
		label: 'Cut';
		icon: (self iconNamed: #smallCut);
		help: 'Cut current entry';
		yourself.
	paste := self newToolbarButton disable;
		label: 'Paste';
		icon: (self iconNamed: #smallPaste);
		help: 'Paste saved entry under current entry';
		yourself.
	delete := self newToolbarButton disable;
		label: 'Delete';
		icon: (self iconNamed: #smallDelete);
		help: 'Delete current entry';
		yourself.
	modify := self newToolbarButton disable;
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
	cut disable.
	modify disable.
]

{ #category : 'updating' }
LDAPEntryToolbarPresenter >> update: anEntry [

	| isLeaf |
	anEntry ifNil: [ ^ self reset ].
	
	isLeaf := anEntry branches isEmpty.
	delete enabled: isLeaf.
	cut enabled: isLeaf.
	modify enabled: isLeaf.
]
