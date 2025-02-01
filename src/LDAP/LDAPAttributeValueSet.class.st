"
I am a virtual element used in partial attribute list to ensure I am a set of strings.
"
Class {
	#name : 'LDAPAttributeValueSet',
	#superclass : 'BERSet',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'instance creation' }
LDAPAttributeValueSet >> newElementFrom: aTagValue [
	
	^ LDAPString new
]
