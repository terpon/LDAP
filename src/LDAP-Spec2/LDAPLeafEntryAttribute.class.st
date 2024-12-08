"
I represent one pair { description. value } of an attribute in the entry.

If the entry has multiple values for a given attribute type, multiple instances on the entry attribute will be present.
"
Class {
	#name : 'LDAPLeafEntryAttribute',
	#superclass : 'LDAPEntryAttribute',
	#instVars : [
		'state'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPLeafEntryAttribute >> isLeaf [ 

	^ true
]

{ #category : 'printing' }
LDAPLeafEntryAttribute >> printOn: aStream [

	super printOn: aStream.
	aStream space;
		nextPut: $(; nextPutAll: self state asString; nextPut: $)
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> state [

	^ state ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> state: anObject [

	state := anObject
]
