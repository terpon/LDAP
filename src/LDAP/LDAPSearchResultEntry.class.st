"
An entry from a search result
"
Class {
	#name : 'LDAPSearchResultEntry',
	#superclass : 'LDAPSearchPartialResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
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

	^ Array streamContents: [ :stream | self attributes flattenOn: stream ]
]

{ #category : 'testing' }
LDAPSearchResultEntry >> isReference [
	^ false
]

{ #category : 'accessing' }
LDAPSearchResultEntry >> name [
	^ elements first value
]

{ #category : 'instance creation' }
LDAPSearchResultEntry >> newElementFrom: aTagValue [
	
	"First element is the matched DN"
	elements ifEmpty: [ ^ BEROctetString new ].

	"Next are partial attributes"
	^ LDAPPartialAttributeList new
]
