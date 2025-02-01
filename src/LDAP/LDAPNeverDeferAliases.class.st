"
I mean the server should not dereference any aliases that it may encounter when processing the search operation.
"
Class {
	#name : 'LDAPNeverDeferAliases',
	#superclass : 'LDAPSearchDerefAliases',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPNeverDeferAliases >> initialize [ 
	super initialize.
	integer := 0. "never"
]

{ #category : 'accessing' }
LDAPNeverDeferAliases >> name [
	^ 'neverDerefAliases'
]
