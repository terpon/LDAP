"
Substrings as filter
"
Class {
	#name : 'LDAPFilterSubstrings',
	#superclass : 'BERSequence',
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPAnySubstring new content: aSubstring); yourself

]

{ #category : 'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atEndOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPFinalSubstring new content: aSubstring); yourself

]

{ #category : 'instance creation' }
LDAPFilterSubstrings class >> containing: aSubstring atStartOf: anAttrType [
	^ self new type: anAttrType; addSubstring: (LDAPInitialSubstring new content: aSubstring); yourself

]

{ #category : 'accessing' }
LDAPFilterSubstrings class >> tagValue [
	^ 16rA4 "Context 4"
]

{ #category : 'adding' }
LDAPFilterSubstrings >> addSubstring: aSubString [
	elements second addElement: aSubString.
]

{ #category : 'initialization' }
LDAPFilterSubstrings >> initialize [ 
	super initialize.

	self addElement: (LDAPString new).
	self addElement: (BERSequence new).

]

{ #category : 'accessing' }
LDAPFilterSubstrings >> type: aString [
	elements first content: aString.
]
