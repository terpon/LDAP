"
I am an option DN string.

(Context 0)
"
Class {
	#name : 'LDAPOptionalDN',
	#superclass : 'BEROctetString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPOptionalDN class >> tagValue [
	^ 16r80 "Context 0"
]
