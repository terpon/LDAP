Class {
	#name : 'LDAPNameIterator',
	#superclass : 'Object',
	#instVars : [
		'base',
		'path'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'instance creation' }
LDAPNameIterator class >> new: aString relativeTo: aRoot [

	^ self new from: aString relativeTo: aRoot
]

{ #category : 'accessing' }
LDAPNameIterator >> base [

	^ base
]

{ #category : 'instance creation' }
LDAPNameIterator >> from: aString relativeTo: aRoot [
	
	| relative |
	base := aRoot.
	"Simplified version, non-canonical RDNs can be more tricky"
	relative := (aString endsWith: aRoot) ifFalse: [ aString ] 
		ifTrue: [ aString copyFrom: 1 to: (aString size - base size - 1) ].
	path := relative splitOn: $,.
]

{ #category : 'testing' }
LDAPNameIterator >> isLeaf [

	^ path isEmpty
]

{ #category : 'iterating' }
LDAPNameIterator >> next [
	
	| aPathSegment |
	path ifEmpty: [ ^self ].
	aPathSegment := path removeLast.
	^ base := aPathSegment, ',', base.
]
