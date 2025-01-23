"
I will only match an entry if at least one of the encapsulated filters matches that entry.
"
Class {
	#name : 'LDAPFilterOr',
	#superclass : 'LDAPFilterWithSet',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterOr class >> tagValue [
	^ 16rA1 "Context 1"
]

{ #category : 'converting' }
LDAPFilterOr >> asOrElements [ 
	^ elements
]
