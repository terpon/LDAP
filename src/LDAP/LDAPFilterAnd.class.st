"
I will only match an entry if all of the encapsulated filters match that entry.
"
Class {
	#name : 'LDAPFilterAnd',
	#superclass : 'LDAPFilterWithSet',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterAnd class >> tagValue [
	^ 16rA0 "Context 0"
]

{ #category : 'converting' }
LDAPFilterAnd >> asAndElements [ 
	^ elements
]
