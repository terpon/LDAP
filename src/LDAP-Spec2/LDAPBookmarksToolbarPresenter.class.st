"
I am the toolbar with buttons to edit a directory entry
"
Class {
	#name : 'LDAPBookmarksToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar',
		'save',
		'delete',
		'close',
		'connectAction',
		'connectDefaultAction',
		'connectMenu',
		'connectButton'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPBookmarksToolbarPresenter class >> example [
	| toolbar |
	toolbar := self new.
	toolbar connectDefaultAction: [ toolbar inform: 'Connect' ].
	^ toolbar open
]

{ #category : 'examples' }
LDAPBookmarksToolbarPresenter class >> exampleConnect [
	| toolbar |
	toolbar := self new.
	toolbar connectDefaultAction: [ toolbar inform: 'Connect' ].
	toolbar addConnect: 'Command 1' action: [ toolbar inform: 'Command 1' ].
	toolbar addConnect: 'Command 2' action: [ toolbar inform: 'Command 2' ].
	toolbar addConnect: 'Command 3' action: [ toolbar inform: 'Command 3' ].
	^ toolbar open
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> addConnect: aString action: aBlock [

	connectMenu menuGroups first addItem: [ :anItem |
		anItem name: aString;
			action: [ connectButton label: aString. self connectAction: aBlock ]
	]
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectAction [

	^ connectAction ifNil: [ ^ self connectDefaultAction ]
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectAction: aBlock [

	connectAction := aBlock
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectDefaultAction [

	^ connectDefaultAction ifNil: [ ^ [ "nothing" ] ]
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectDefaultAction: aBlock [

	connectDefaultAction := aBlock
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectMenu [

	connectMenu menuGroups first menuItems ifEmpty: [  
		connectMenu menuGroups first addItem: [ :anItem | anItem name: 'Connect'; action: [ self connectDefaultAction value ] ]
	].
	^ connectMenu
]

{ #category : 'initialization' }
LDAPBookmarksToolbarPresenter >> connectPresenters [ 

	super connectPresenters.
	close action: [ self withWindowDo: [ :w | w close ] ].

]

{ #category : 'layout' }
LDAPBookmarksToolbarPresenter >> defaultLayout [ 
	^ SpBoxLayout newLeftToRight 
		add: toolbar;
		yourself
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> deleteButton [

	^ delete
]

{ #category : 'initialization' }
LDAPBookmarksToolbarPresenter >> initializePresenters [
	
	connectMenu := self newMenu
		addGroup: [ :aGroup | "Empty for now" ];
		yourself.
	connectButton := self newToolbarMenuButton
		label: 'Connect';
		icon: (self iconNamed: #smallHome);
		help: 'Open a browser window with current server information';
		menu: [ self connectMenu ];
		action: [ self connectAction value ]
		yourself.
	save := self newToolbarButton
		label: 'Save';
		icon: (self iconNamed: #smallSave);
		help: 'Save or Replace the entry to the preference file';
		yourself.
	delete := self newToolbarButton
		label: 'Delete';
		icon: (self iconNamed: #smallDelete);
		help: 'Delete current entry from the preference file';
		yourself.
	close := self newToolbarButton
		label: 'Cancel';
		icon: (self iconNamed: #smallCancel);
		help: 'Close current window';
		yourself.
	toolbar := self newToolbar
		           beBoth; "icons and text"
		           addItemLeft: save;
		           addItemLeft: delete;
		           addItemRight: connectButton;
		           addItemRight: close;
		           yourself
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> saveButton [

	^ save
]
