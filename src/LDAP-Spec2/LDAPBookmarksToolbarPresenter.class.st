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
		'connectButton'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPBookmarksToolbarPresenter class >> example [
	^ self new open
]

{ #category : 'examples' }
LDAPBookmarksToolbarPresenter class >> exampleConnect [
	| toolbar group |
	toolbar := self new.
	group := (SpActionGroup newName: 'Example')
		addActionWith: [ :anItem | anItem
			name: 'Command 1';
			description: 'this is the first action';
			action: [ toolbar inform: 'Command 1' ] ];
		addActionWith: [ :anItem | anItem
			name: 'Command 2';
			description: 'this is the second action';
			action: [ toolbar inform: 'Command 2' ] ];
		addActionWith: [ :anItem | anItem
			name: 'Command 3';
			description: 'this is the third action';
			action: [ toolbar inform: 'Command 3' ] ].
	toolbar connectActions: group.
	^ toolbar open
]

{ #category : 'accessing' }
LDAPBookmarksToolbarPresenter >> connectActions: aGroup [

	| first |
	first := aGroup entries first.
	connectAction := first.
	connectButton enabled: true;
		label: first name;
		menu: [ SpMenuPresenter new 
			addGroup: [ :group |
				aGroup entries do: [ :anAction | group addItem: [ :item | 
						item name: anAction name; action: [ 
							connectButton label: anAction name. 
							connectAction := anAction
						] 
				] ]
			]; yourself ].

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
	
	connectButton := self newToolbarMenuButton
		enabled: false;
		label: 'Connect';
		icon: (self iconNamed: #smallHome);
		help: 'Open a browser window with current server information';
		action: [ connectAction ifNotNil: [ :action | action execute ] ]
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
		label: 'Close';
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
