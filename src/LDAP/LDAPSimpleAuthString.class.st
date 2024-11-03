"
I am a password string.
"
Class {
	#name : 'LDAPSimpleAuthString',
	#superclass : 'BEROctetString',
	#category : 'LDAP-ContextElements',
	#package : 'LDAP',
	#tag : 'ContextElements'
}

{ #category : 'accessing' }
LDAPSimpleAuthString class >> tagValue [
	^ 16r80 "Context 0"
]
