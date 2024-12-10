"
I represent a RDN attribute for a LDAP entry.
"
Class {
	#name : 'LDAPBranchEntryAttribute',
	#superclass : 'LDAPEntryAttribute',
	#instVars : [
		'attributes'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> content [

	^ String streamContents: [ :out | 
		attributes do: [ :leaf | out nextPutAll: leaf content ] 
			separatedBy: [ out nextPut: $, ] 
	]
]

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> description [ 

	^ String streamContents: [ :out | 
		attributes do: [ :leaf | out nextPutAll: leaf description ] 
			separatedBy: [ out nextPut: $, ] 
	]
]

{ #category : 'testing' }
LDAPBranchEntryAttribute >> isLeaf [ 

	^ false
]

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> name [

	^ String streamContents: [ :out | 
		attributes do: [ :leaf | out nextPutAll: leaf name ] 
			separatedBy: [ out nextPut: $+ ] 
	]
]

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> name: aString [

	attributes := self class leavesFromRelativeNameIn: aString
]
