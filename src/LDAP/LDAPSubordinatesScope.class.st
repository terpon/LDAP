"
I mean the baseObject entry will not be considered, but all of its subordinates to any depth will be considered.
"
Class {
	#name : 'LDAPSubordinatesScope',
	#superclass : 'LDAPSearchScope',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPSubordinatesScope >> initialize [ 
	super initialize.
	integer := 3. "subordinates"
]

{ #category : 'accessing' }
LDAPSubordinatesScope >> name [
	^ 'subordinatesSubtree'
]
