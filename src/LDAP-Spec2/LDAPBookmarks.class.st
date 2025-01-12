"
I manage a list of Association instances `name -> LDAPServerInfo`
"
Class {
	#name : 'LDAPBookmarks',
	#superclass : 'SpApplication',
	#instVars : [
		'bookmarks',
		'preferences'
	],
	#classVars : [
		'StoreLocation'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'configuration' }
LDAPBookmarks class >> defaultPreferences [

	^ FileLocator preferences / 'ldap-pharo' / 'bookmarks.ston'
]

{ #category : 'settings' }
LDAPBookmarks class >> settingsOn: aBuilder [
	(aBuilder group: #LDAPBookmarks )
		parent: #LDAP;
		label: 'Server Bookmarks';
		description: 'Settings for the LDAP Server Bookmarks';
		noOrdering;
		with: [
			(aBuilder setting: #storeFile)
				target: self;
				type: #FilePathEncoder;
				default: self defaultPreferences;
				label: 'Location of default bookmarks file';
				description: 'Default is ''{preferences}/ldap-pharo/bookmarks.ston''. The password are stored in plain text'.
		].
]

{ #category : 'examples' }
LDAPBookmarks class >> start [
<example>
	^ self new start
]

{ #category : 'accessing' }
LDAPBookmarks class >> storeFile [

	^ StoreLocation ifNil: [ StoreLocation := self defaultPreferences ]
]

{ #category : 'accessing' }
LDAPBookmarks class >> storeFile: aString [

	StoreLocation := aString asFileLocatorOrReference
]

{ #category : 'accessing' }
LDAPBookmarks >> bookmarks [ 

	^ bookmarks ifNil: [ bookmarks := #() ]
]

{ #category : 'accessing' }
LDAPBookmarks >> bookmarks: aCollection [

	bookmarks := aCollection
]

{ #category : 'accessing - file' }
LDAPBookmarks >> delete [

	[ self preferences ensureDelete ]
	on: Error do: [ "ignore" ]
]

{ #category : 'installing' }
LDAPBookmarks >> load [

	self preferences exists ifFalse: [ bookmarks := #(). ^self ].
	bookmarks := self preferences readStreamDo: [ :aReadStream | STON fromStream: aReadStream ]
]

{ #category : 'instance creation' }
LDAPBookmarks >> newBrowser: aServerInfo [

	^ self open: LDAPBrowser on: aServerInfo

]

{ #category : 'instance creation' }
LDAPBookmarks >> newEditor: aServerInfo [

	^ self open: LDAPEditor on: aServerInfo

]

{ #category : 'private - factory' }
LDAPBookmarks >> open: aClass on: aServerInfo [

	| application |
	aServerInfo hostname ifEmpty: [ ^self inform: 'No hostname defined' ].
	application:= aClass new.
	application start.
	application connectTo: aServerInfo.
	^ application

]

{ #category : 'accessing' }
LDAPBookmarks >> preferences [

	^ preferences ifNil: [ preferences := self class storeFile ]
]

{ #category : 'accessing' }
LDAPBookmarks >> preferences: aLocation [

	preferences := aLocation
]

{ #category : 'load and saving' }
LDAPBookmarks >> save [

	self delete.
	self preferences parent ensureCreateDirectory.
	self preferences binaryWriteStreamDo: [ :aStream |
		STON put: bookmarks onStreamPretty: (ZnCharacterWriteStream on: aStream encoding: 'utf8')
	].

]

{ #category : 'running' }
LDAPBookmarks >> start [
<script: 'self start'>
	
	| aPresenter |
	self load.
	aPresenter := LDAPBookmarkEditor 
		          newApplication: self
		          model: self bookmarks.
	aPresenter onBookmarksChangeDo: [ :b | self bookmarks: b asArray. self save ].
	^ aPresenter open
]
