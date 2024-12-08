"
I represent a RDN attribute for a LDAP entry.
"
Class {
	#name : 'LDAPBranchEntryAttribute',
	#superclass : 'LDAPEntryAttribute',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPBranchEntryAttribute >> isLeaf [ 

	^ false
]
