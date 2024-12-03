"
I am a password string.
"
Class {
	#name : 'LDAPSimpleAuthString',
	#superclass : 'LDAPString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPSimpleAuthString class >> tagValue [
	^ 16r80 "Context 0"
]
