"
I am a set of controls in a LDAP message.
"
Class {
	#name : 'LDAPControls',
	#superclass : 'BERSequence',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPControls class >> tagValue [
	^ 16rA0 "Context 0"
]
