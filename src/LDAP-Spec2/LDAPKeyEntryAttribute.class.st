"
I am a leaf attribute of the entry but also part of the RDN
"
Class {
	#name : 'LDAPKeyEntryAttribute',
	#superclass : 'LDAPLeafEntryAttribute',
	#category : 'LDAP-Spec2-Entries',
	#package : 'LDAP-Spec2',
	#tag : 'Entries'
}

{ #category : 'testing' }
LDAPKeyEntryAttribute >> isKey [
	"Returns true if this attribute is part of the RDN"
	^ true
]
