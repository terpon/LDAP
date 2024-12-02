"
I keep LDAP cached entry in a hierarchical way. When an entry is invalidated, we need to invalidate all the entries benath (we’ll just remove them from the data structure).
"
Class {
	#name : 'LDAPCache',
	#superclass : 'Object',
	#instVars : [
		'rootDN',
		'rootEntry'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPCache >> at: aDN for: anApplication [
"Create or update the entry"
	| aCachedEntry |
	aDN isEmptyOrNil ifTrue: [ ^ rootEntry entry ].
	aCachedEntry := self search: aDN.
	anApplication isConnected ifTrue: [ aCachedEntry update: anApplication ].
	^ aCachedEntry entry


]

{ #category : 'initialization' }
LDAPCache >> initialize [ 

	super initialize.
	
	self root: ''.
]

{ #category : 'accessing' }
LDAPCache >> root: aString [

	(aString = rootDN) ifTrue: [ ^self ].
	rootDN := aString.
	rootEntry := LDAPCachedEntry for: rootDN. 
]

{ #category : 'private - searching' }
LDAPCache >> search: aString [
"Create or update the entry"
	| aDN |
	(aString = rootDN) ifTrue: [ ^ rootEntry ].
	aDN := LDAPNameIterator new: aString relativeTo: rootDN.
	^ rootEntry search: aDN

]
