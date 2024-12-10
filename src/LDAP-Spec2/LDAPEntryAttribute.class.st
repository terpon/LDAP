"
I represent one line in the LDAPEntryPresenter.

I am construted from LDAPSearchResult responses to be either a leaf attribute (in the partial attribute) or a attribute with deeper children.

I respond to `description` and `value` messages for display.
"
Class {
	#name : 'LDAPEntryAttribute',
	#superclass : 'Object',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'helper' }
LDAPEntryAttribute class >> leavesFromRelativeNameIn: aString [

	| pairs |
	pairs := LDAPName firstAsPairs: aString.
	^ pairs collect: [ :pair | LDAPLeafEntryAttribute newFromPair: pair ]
]

{ #category : 'comparing' }
LDAPEntryAttribute >> = anAttribute [

	^ self name = anAttribute name
]

{ #category : 'accessing' }
LDAPEntryAttribute >> content [

	self subclassResponsibility.
	^ ''
]

{ #category : 'accessing' }
LDAPEntryAttribute >> description [

	self subclassResponsibility.
	^ ''
]

{ #category : 'comparing' }
LDAPEntryAttribute >> hash [

	^ self name hash
]

{ #category : 'testing' }
LDAPEntryAttribute >> isEmpty [

	^ self description isEmpty and: [ self content isEmpty ]
]

{ #category : 'testing' }
LDAPEntryAttribute >> isLeaf [

	^ self subclassResponsibility 
]

{ #category : 'testing' }
LDAPEntryAttribute >> isValid [

	^ self description isNotEmpty and: [ self content isNotEmpty ]
]

{ #category : 'accessing' }
LDAPEntryAttribute >> name [

	self subclassResponsibility.
	^ ''
]

{ #category : 'printing' }
LDAPEntryAttribute >> printOn: aStream [
	super printOn: aStream.
	aStream space; nextPut: $'; nextPutAll: self name; nextPut: $'
]
