"
I will match a value that starts with a specified string.
"
Class {
	#name : 'LDAPInitialSubstring',
	#superclass : 'LDAPSubstring',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPInitialSubstring class >> tagValue [
	^ 16r80 "Context 0"
]
