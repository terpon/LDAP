"
I am a BERSequence of LDAPPartialAttribute elements
"
Class {
	#name : 'LDAPPartialAttributeList',
	#superclass : 'BERSequence',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'instance creation' }
LDAPPartialAttributeList >> newElementFrom: aTagValue [

	"All elements are partial attributes"
	^ LDAPPartialAttribute new
]
