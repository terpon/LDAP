"
I am an option DN string.

(Context 0)
"
Class {
	#name : 'LDAPOptionalName',
	#superclass : 'LDAPString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPOptionalName class >> tagValue [
	^ 16r80 "Context 0"
]
