"
The server should always dereference any aliases encountered within the scope of the search.
"
Class {
	#name : 'LDAPAlwaysDeferAliases',
	#superclass : 'LDAPSearchDerefAliases',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPAlwaysDeferAliases >> initialize [ 
	super initialize.
	value := 3. "always"
]

{ #category : 'accessing' }
LDAPAlwaysDeferAliases >> name [
	^ 'alwaysDerefAliases'
]
