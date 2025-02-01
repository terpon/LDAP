"
I manage global state for the LDAP packages
"
Class {
	#name : 'LDAPState',
	#superclass : 'Object',
	#classVars : [
		'InWorldMenu'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'adding' }
LDAPState class >> addToWorldMenu [

	^ InWorldMenu ifNil: [ InWorldMenu := true ]
]

{ #category : 'adding' }
LDAPState class >> addToWorldMenu: aBoolean [

	(InWorldMenu = aBoolean) ifTrue: [ ^self ]. 
	InWorldMenu := aBoolean.
	MenubarMorph showMenubar: MenubarMorph showMenubar.
]

{ #category : 'keymaps' }
LDAPState class >> openSettings [
	<script>
	"Snippet copied from IceTipSettingsCommand>>execute"
	| packages browser window path |
	packages := self packageOrganizer packages select: [ :p | p name beginsWith: 'LDAP' ].
	browser := SettingBrowser new 
		changePackageSet: packages;
		yourself.
	
	window := browser open.
	path := (window submorphs detect: [ :each | (each isKindOf: MorphTreeMorph) ]) nodeList.
	browser expandNodePath: path first path.
]

{ #category : 'settings' }
LDAPState class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #LDAP)
		label: 'LDAP';
		description: 'All LDAP settings';
		noOrdering;
		with: [
			(aBuilder setting: #addToWorldMenu)
				label: 'Add LDAP entries to the World Menu';
				default: true;
				target: self;
				description: 'When enabled a LDAP submenu is add to the World Menu and the Menu Bar.' .
		].
	LDAPBookmarks settingsOn: aBuilder.
]

{ #category : 'world menu' }
LDAPState class >> worldMenuOn: aBuilder [
	<worldMenu>
	self addToWorldMenu ifFalse: [ ^self ].
	(aBuilder item: #LDAP)
		label: 'LDAP';
		order: 35;
		with: [
			(aBuilder group: #'LDAP Applications')
				order: 1;
				with: [
					(aBuilder item: #'Server Bookmarks')
						action: [ LDAPBookmarks start ];
						help: 'Open the saved Server Bookmarks window';
						order: 1.
					(aBuilder item: #Browser)
						action: [ LDAPBrowser start ];
						help: 'Open an empty LDAP browser';
						order: 50.
					(aBuilder item: #Editor)
						action: [ LDAPEditor start ];
						help: 'Open an empty LDAP editor';
						order: 51.
					aBuilder	withSeparatorAfter ].
			(aBuilder group: #'LDAP Settings')
				order: 80;
				with: [
					(aBuilder item: #'Open Settings')
						action: [ self openSettings ];
						help: 'Open the Settings browser for LDAP';
						order: 5.
					aBuilder	withSeparatorAfter ].
		].
]

{ #category : 'keymaps' }
LDAPState >> openSettings [
<script: 'self openSettings'>

	^ self class openSettings
]
