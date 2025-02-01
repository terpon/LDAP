"
I mean the baseObject entry will be considered, as well as all of its subordinates to any depth.
"
Class {
	#name : 'LDAPWholeSubtreeScope',
	#superclass : 'LDAPSearchScope',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPWholeSubtreeScope >> initialize [ 
	super initialize.
	integer := 2. "whole subtree"
]

{ #category : 'accessing' }
LDAPWholeSubtreeScope >> name [
	^ 'wholeSubtree'
]
