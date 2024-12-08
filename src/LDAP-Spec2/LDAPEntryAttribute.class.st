"
I represent one line in the LDAPEntryPresenter.

I am construted from LDAPSearchResult responses to be either a leaf attribute (in the partial attribute) or a attribute with deeper children.

I respond to `description` and `value` messages for display.
"
Class {
	#name : 'LDAPEntryAttribute',
	#superclass : 'Object',
	#instVars : [
		'description',
		'content'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPEntryAttribute >> content [

	^ content ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPEntryAttribute >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
LDAPEntryAttribute >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPEntryAttribute >> description: anObject [

	description := anObject
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
	^ String streamContents: [ :out |
		out nextPutAll: self description; nextPut: $=; nextPutAll: self content
	]
]

{ #category : 'printing' }
LDAPEntryAttribute >> printOn: aStream [
	super printOn: aStream.
	aStream space; nextPut: $'; nextPutAll: self name; nextPut: $'
]
