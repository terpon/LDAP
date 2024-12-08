"
I represent an entry in a LDAP directory.

Search requests for a DN either returns the whole subtree, the attributes for the given DN or the entries just beneath. Unless asking for the whole subtree, there is no way to get both the attributes for the DN and the relative DNs of its sub-entries.

I keep two lists, one of `LDAPBranchEntryAttribute` instances and one of `LDAPLeafEntryAttribute` instances.
"
Class {
	#name : 'LDAPEntryModel',
	#superclass : 'Model',
	#instVars : [
		'name',
		'branches',
		'leaves'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPEntryModel >> attributes [

	^ branches, leaves
]

{ #category : 'accessing' }
LDAPEntryModel >> branches [

	^ branches
]

{ #category : 'accessing' }
LDAPEntryModel >> firstPairFrom: aString [

	| rdn |
	rdn := aString copyUpToSubstring: ','.
	^ rdn splitOn: $=
	
]

{ #category : 'initialization' }
LDAPEntryModel >> initialize [ 

	super initialize.
	
	branches := OrderedCollection new.
	leaves := OrderedCollection new.
]

{ #category : 'accessing' }
LDAPEntryModel >> leaves [

	^ leaves
]

{ #category : 'accessing' }
LDAPEntryModel >> name [
"Full DN"
	^ name
]

{ #category : 'accessing' }
LDAPEntryModel >> name: anObject [

	name := anObject.
	self valueChanged
]

{ #category : 'initialization' }
LDAPEntryModel >> populateFromPartialAttributeList: anObject [
"only leaves"

	leaves := anObject flattened collect: [ :pair |
		LDAPLeafEntryAttribute new 
			description: pair first; 
			content: pair second; yourself 
		].
	self valueChanged
]

{ #category : 'initialization' }
LDAPEntryModel >> populateFromResults: aCollection [
"at this level all results are children on the current entry"
	| elements |
	elements := aCollection reject: [ :each | each isReference ].
	branches := elements collect: [ :each | | dn pair |
		dn := each name.
		pair := self firstPairFrom: dn.
		LDAPBranchEntryAttribute new 
			description: pair first; 
			content: pair second; 
			yourself 
	].
	self valueChanged
]
