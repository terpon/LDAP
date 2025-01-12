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
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'examples' }
LDAPBookmarks class >> start [
<example>
	^ self new start
]

{ #category : 'accessing' }
LDAPBookmarks >> bookmarks [ 

	^ bookmarks ifNil: [ bookmarks := #() ]
]

{ #category : 'accessing' }
LDAPBookmarks >> bookmarks: aCollection [

	bookmarks := aCollection
]

{ #category : 'configuration' }
LDAPBookmarks >> defaultPreferences [
	^ FileLocator preferences / 'ldap-pharo' / 'bookmarks.ston'
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

	^ preferences ifNil: [ preferences := self defaultPreferences ]
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
