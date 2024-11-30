"
I represent a RDN attribute for a LDAP entry.
"
Class {
	#name : 'LDAPBranchEntryAttribute',
	#superclass : 'LDAPEntryAttribute',
	#instVars : [
		'name'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> icon: anIconProvider [

	^ anIconProvider iconNamed: #smallOpen
]

{ #category : 'testing' }
LDAPBranchEntryAttribute >> isLeaf [ 

	^ false
]

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> name [

	^ name
]

{ #category : 'accessing' }
LDAPBranchEntryAttribute >> name: anObject [

	name := anObject
]
