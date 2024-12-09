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

{ #category : 'accessing' }
LDAPPartialAttributeList >> at: aDescription put: someValues [

	^ elements
			detect: [ :pa | pa description = aDescription ] 
			ifFound: [ :pa | pa values: someValues ] 
			ifNone: [ self addElement: (LDAPPartialAttribute new description: aDescription; values: someValues) ]
]

{ #category : 'accessing' }
LDAPPartialAttributeList >> attributes: aDictionary [
	self removeAll.
	aDictionary associationsDo: [ :a | self at: a key put: a value ].

]

{ #category : 'enumerating' }
LDAPPartialAttributeList >> flattenOn: aStream [

	elements do: [ :partialAttribute | partialAttribute flattenOn: aStream ]
]

{ #category : 'converting' }
LDAPPartialAttributeList >> flattened [ 

	^ Array streamContents: [ :stream | self flattenOn: stream ]
]

{ #category : 'instance creation' }
LDAPPartialAttributeList >> newElementFrom: aTagValue [

	"All elements are partial attributes"
	^ LDAPPartialAttribute new
]
