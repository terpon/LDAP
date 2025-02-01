"
I am an helper class to help instantiate LDAP filterst for searches into the directory.

LDAP filters are composite objects forming a syntax tree for search filtering.
"
Class {
	#name : 'LDAPFilter',
	#superclass : 'Object',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'instance creation' }
LDAPFilter class >> andOf: someFilters [
	| set |
	set := LDAPFilterAnd new.
	someFilters do: [ :each | set addElement: each ].
	^ set

]

{ #category : 'instance creation' }
LDAPFilter class >> containing: aSubstring atAnywhereOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atAnywhereOf: anAttrType
]

{ #category : 'instance creation' }
LDAPFilter class >> containing: aSubstring atEndOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atEndOf: anAttrType
]

{ #category : 'instance creation' }
LDAPFilter class >> containing: aSubstring atStartOf: anAttrType [
	^ LDAPFilterSubstrings containing: (aSubstring utf8Encoded asString) atStartOf: anAttrType
]

{ #category : 'instance creation' }
LDAPFilter class >> not: aFilter [
	^ LDAPFilterNot filter: aFilter
]

{ #category : 'instance creation' }
LDAPFilter class >> orOf: someFilters [
	| set |
	set := LDAPFilterOr new.
	someFilters do: [ :each | set addElement: each ].
	^ set

]

{ #category : 'instance creation' }
LDAPFilter class >> with: anAttrType [
	^ LDAPFilterPresent having: anAttrType
]

{ #category : 'instance creation' }
LDAPFilter class >> with: anAttrType equalTo: anAttrValue [
	^ LDAPFilterEquality new description: anAttrType; assertionValue: anAttrValue
]

{ #category : 'instance creation' }
LDAPFilter class >> with: anAttrType greaterOrEqualThan: anAttrValue [
	^ LDAPFilterGreaterOrEqual new description: anAttrType; assertionValue: anAttrValue
	
]

{ #category : 'instance creation' }
LDAPFilter class >> with: anAttrType lessOrEqualThan: anAttrValue [
	^ LDAPFilterLessOrEqual new description: anAttrType; assertionValue: anAttrValue
]

{ #category : 'instance creation' }
LDAPFilter class >> with: anAttrType notEqualTo: anAttrValue [
	^self not: (self with: anAttrType equalTo: (anAttrValue utf8Encoded asString))
]
