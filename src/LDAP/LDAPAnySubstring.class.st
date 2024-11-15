"
I am a string used to look anywhere in another string.
"
Class {
	#name : 'LDAPAnySubstring',
	#superclass : 'LDAPSubstring',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPAnySubstring class >> tagValue [
	^ 16r81 "Context 1"
]
