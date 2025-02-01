"
I mean the server should only dereference the entry specified by the baseObject element of the request.
"
Class {
	#name : 'LDAPFindingBaseDeferAliases',
	#superclass : 'LDAPSearchDerefAliases',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPFindingBaseDeferAliases >> initialize [ 
	super initialize.
	integer := 2. "finding base object"
]

{ #category : 'accessing' }
LDAPFindingBaseDeferAliases >> name [
	^ 'derefFindingBaseObj'
]
