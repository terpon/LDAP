"
I wrap an entry model to managed loading of attributes.
"
Class {
	#name : 'LDAPCachedEntry',
	#superclass : 'Object',
	#instVars : [
		'entry',
		'children',
		'state',
		'updateProcess'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'instance creation' }
LDAPCachedEntry class >> for: aDN [

	| anEntry |
	anEntry := LDAPEntryModel new name: aDN.
	^ self new entry: anEntry
	
]

{ #category : 'comparing' }
LDAPCachedEntry >> = anObject [

	^ self name = anObject asString
]

{ #category : 'converting' }
LDAPCachedEntry >> asString [

	^ self name
]

{ #category : 'accessing' }
LDAPCachedEntry >> entry [

	^ entry
]

{ #category : 'accessing' }
LDAPCachedEntry >> entry: anEntry [

	entry := anEntry.
	state := LDAPInvalidatedEntryState new.
]

{ #category : 'comparing' }
LDAPCachedEntry >> hash [

	^ self name hash
]

{ #category : 'changing state' }
LDAPCachedEntry >> invalidate [

	children := nil.
	
	updateProcess ifNotNil: [ :process | process isTerminated | process isTerminating ifFalse: [ process terminate ] ].
	updateProcess := nil.

	state := state invalidate.
]

{ #category : 'accessing' }
LDAPCachedEntry >> name [

	^ entry ifNotNil: [ entry name ] ifNil: [ '' ]
]

{ #category : 'printing' }
LDAPCachedEntry >> printOn: stream [
	super printOn: stream.
	self name ifNotEmpty: [ :name | stream
		space;
		nextPut: $';
		nextPutAll: name;
		nextPut: $'
	]
]

{ #category : 'accessing' }
LDAPCachedEntry >> search: aDN [
"Create or update the entry"
	| nextBase nextChild |
	(aDN base = entry name) ifFalse: [ ^ nil ].
	aDN isLeaf ifTrue: [ ^ self ].
	
	children ifNil: [ children := Set new ].
	nextBase := aDN next.
	nextChild := children like: nextBase ifAbsent: [ children add: (self class for: nextBase) ].
	^ nextChild search: aDN
]

{ #category : 'updating' }
LDAPCachedEntry >> update: anApplication [

	state atEnd ifTrue: [ ^ self ].
	"Check if update already runnin"
	updateProcess ifNotNil: [ :process | process isTerminated ifFalse: [ ^self ] ].
	
	updateProcess := [ 
		[ anApplication isConnected and: [ state atEnd not ] ] whileTrue: [
			state := state nextFor: entry on: anApplication.
			Processor yield
		]
	] forkAt: Processor userBackgroundPriority named: 'LDAP update ', entry name
]
