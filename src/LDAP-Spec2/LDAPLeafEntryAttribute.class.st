"
I represent one pair { description. value } of an attribute in the entry.

If the entry has multiple values for a given attribute type, multiple instances on the entry attribute will be present.
"
Class {
	#name : 'LDAPLeafEntryAttribute',
	#superclass : 'LDAPEntryAttribute',
	#instVars : [
		'description',
		'content'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'instance creation' }
LDAPLeafEntryAttribute class >> arrayFromRelativeNameIn: aString [

	| rdn |
	rdn := LDAPName firstAsPairs: aString.
	^ rdn collect: [ :pair | self newFromPair: pair ]
]

{ #category : 'instance creation' }
LDAPLeafEntryAttribute class >> copy: anAttribute [

	^ self new 
			description: anAttribute description;
			content: anAttribute content;
			yourself
]

{ #category : 'instance creation' }
LDAPLeafEntryAttribute class >> newFromPair: aPair [

	^ self new 
			description: aPair first; 
			content: aPair second; 
			yourself 
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> content [

	^ content ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> description: anObject [

	description := anObject
]

{ #category : 'testing' }
LDAPLeafEntryAttribute >> isLeaf [ 

	^ true
]

{ #category : 'accessing' }
LDAPLeafEntryAttribute >> name [
	^ String streamContents: [ :out |
		out nextPutAll: self description; nextPut: $=; nextPutAll: self content
	]
]
