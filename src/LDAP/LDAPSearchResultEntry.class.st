"
I am an entry from a `LDAPSearchRequest`.
"
Class {
	#name : 'LDAPSearchResultEntry',
	#superclass : 'LDAPSearchPartialResult',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPSearchResultEntry class >> tagValue [
	^ 16r64
]

{ #category : 'converting' }
LDAPSearchResultEntry >> asDictionary [
	"I return a Dictionary with attribute description as keys. Each value is an collection, as there may be multiple values per attribute."
	^ self attributes asDictionary 

]

{ #category : 'accessing' }
LDAPSearchResultEntry >> attributes [
"Return the attributes (most probably LDAPPartialAttributeList)"
	^ elements second
]

{ #category : 'converting' }
LDAPSearchResultEntry >> flattened [ 

	^ self attributes flattened
]

{ #category : 'testing' }
LDAPSearchResultEntry >> isReference [
	^ false
]

{ #category : 'accessing' }
LDAPSearchResultEntry >> name [
	^ elements first asString
]

{ #category : 'instance creation' }
LDAPSearchResultEntry >> newElementFrom: aTagValue [
	
	"First element is the matched DN"
	elements ifEmpty: [ ^ LDAPString new ].

	"Next are partial attributes"
	^ LDAPPartialAttributeList new
]
