"
Only the entry whose DN is provided in the baseObject element of the request will be considered.

None of its subordinates will be examined.
"
Class {
	#name : 'LDAPBaseObjectScope',
	#superclass : 'LDAPSearchScope',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPBaseObjectScope >> initialize [ 
	super initialize.
	integer := 0. "base object"
]

{ #category : 'accessing' }
LDAPBaseObjectScope >> name [
	^ 'baseObject'
]
