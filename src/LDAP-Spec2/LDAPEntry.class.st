Class {
	#name : 'LDAPEntry',
	#superclass : 'Model',
	#instVars : [
		'name',
		'branches',
		'leaves',
		'needSelfRefresh',
		'needSubRefresh'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPEntry >> attributes [

	^ branches, leaves
]

{ #category : 'accessing' }
LDAPEntry >> firstPairFrom: aString [

	| rdn |
	rdn := aString copyUpToSubstring: ','.
	^ rdn splitOn: $=
	
]

{ #category : 'initialization' }
LDAPEntry >> initialize [ 

	super initialize.
	
	branches := OrderedCollection new.
	leaves := OrderedCollection new.
	needSelfRefresh := true.
	needSubRefresh := true.
]

{ #category : 'invalidate' }
LDAPEntry >> invalidate [

	self invalidateSelf.
	self invalidateSub.
]

{ #category : 'invalidate' }
LDAPEntry >> invalidateSelf [

	needSelfRefresh := true
]

{ #category : 'invalidate' }
LDAPEntry >> invalidateSub [

	needSubRefresh := true
]

{ #category : 'accessing' }
LDAPEntry >> name [
"Full DN"
	^ name
]

{ #category : 'accessing' }
LDAPEntry >> name: anObject [

	name := anObject.
	self valueChanged
]

{ #category : 'accessing' }
LDAPEntry >> needSelfRefresh [

	^ needSelfRefresh 
]

{ #category : 'accessing' }
LDAPEntry >> needSubRefresh [

	^ needSubRefresh 
]

{ #category : 'initialization' }
LDAPEntry >> populateFromPartialAttributeList: anObject [
"only leaves"

	needSelfRefresh := false.
	leaves := anObject flattened collect: [ :pair |
		LDAPLeafEntryAttribute new 
			description: pair first; 
			value: pair second; yourself 
		].
	self valueChanged
]

{ #category : 'initialization' }
LDAPEntry >> populateFromResults: aCollection [
"at this level all results are children on the current entry"
	| elements |
	needSubRefresh := false.
	elements := aCollection reject: [ :each | each isReference ].
	branches := elements collect: [ :each | | dn pair |
		dn := each name.
		pair := self firstPairFrom: dn.
		LDAPBranchEntryAttribute new 
			description: pair first; 
			value: pair second; 
			name: dn; yourself 
	].
	self valueChanged
]
