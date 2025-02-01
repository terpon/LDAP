"
I will match a value that contains anywhere a specified string
"
Class {
	#name : 'LDAPAnySubstring',
	#superclass : 'LDAPSubstring',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPAnySubstring class >> tagValue [
	^ 16r81 "Context 1"
]
