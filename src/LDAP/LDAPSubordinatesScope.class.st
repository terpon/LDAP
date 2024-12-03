"
The baseObject entry will be considered, as well as all of its subordinates to any depth.
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
