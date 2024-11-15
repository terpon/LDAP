"
I am a string used to look at the beginning of another string.
"
Class {
	#name : 'LDAPInitialSubstring',
	#superclass : 'LDAPSubstring',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPInitialSubstring class >> tagValue [
	^ 16r80 "Context 0"
]
