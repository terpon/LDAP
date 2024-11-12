"
I am a BERSequence of LDAPPartialAttribute elements
"
Class {
	#name : 'LDAPPartialAttributeList',
	#superclass : 'BERSequence',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'converting' }
LDAPPartialAttributeList >> asDictionary [
	"I return a Dictionary with attributes as keys and values in a Set"
	^ (elements collect: #asAssociation) asDictionary

]

{ #category : 'enumerating' }
LDAPPartialAttributeList >> flattenOn: aStream [

	elements do: [ :partialAttribute | partialAttribute flattenOn: aStream ]
]

{ #category : 'instance creation' }
LDAPPartialAttributeList >> newElementFrom: aTagValue [

	"All elements are partial attributes"
	^ LDAPPartialAttribute new
]
