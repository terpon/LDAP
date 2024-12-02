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

{ #category : 'accessing' }
LDAPCachedEntry >> entry [

	^ entry
]

{ #category : 'accessing' }
LDAPCachedEntry >> entry: anEntry [

	entry := anEntry.
	state := LDAPInvalidatedEntryState new.
]

{ #category : 'changing state' }
LDAPCachedEntry >> invalidate [

	children := nil.
	
	updateProcess ifNotNil: [ :process | process isTerminated | process isTerminating ifFalse: [ process terminate ] ].
	updateProcess := nil.

	state := state invalidate.
]

{ #category : 'accessing' }
LDAPCachedEntry >> search: aDN [
"Create or update the entry"
	| nextChild |
	(aDN base = entry name) ifFalse: [ ^ nil ].
	aDN isLeaf ifTrue: [ ^ self ].
	
	children ifNil: [ children := Dictionary new ].
	aDN next.
	nextChild := children at: aDN base ifAbsentPut: [ self class for: aDN base ].
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
