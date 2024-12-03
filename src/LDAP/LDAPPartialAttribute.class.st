"
I am a pseudo BERElement representing an attribute and its values.

I am not a real BER element because I don't have a specific tag and cannot be created from a stream. I am here to help encoding LDAP messages.
My name implies I can be empty.

From RFC4511:
 Attributes and partial attributes consist of an attribute description
   and attribute values.  A PartialAttribute allows zero values, while
   Attribute requires at least one value.
"
Class {
	#name : 'LDAPPartialAttribute',
	#superclass : 'BERSequence',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'adding' }
LDAPPartialAttribute >> addValue: aString [
	elements second addElement: (LDAPString new content: aString).
]

{ #category : 'converting' }
LDAPPartialAttribute >> asAssociation [

	^	self description -> self values

]

{ #category : 'accessing' }
LDAPPartialAttribute >> description [
	^ elements first asString
]

{ #category : 'accessing' }
LDAPPartialAttribute >> description: aString [ 
	elements first content: aString
]

{ #category : 'enumerating' }
LDAPPartialAttribute >> flattenOn: aStream [
	| name |
	name := self description.
	elements second do: [ :each |  aStream nextPut: { name. each asString }  ]
]

{ #category : 'initialization' }
LDAPPartialAttribute >> initialize [ 
	super initialize.
	
	self addElement: (LDAPString new). "type"
	self addElement: (LDAPAttributeValueSet new). "vals"

]

{ #category : 'instance creation' }
LDAPPartialAttribute >> newElementFrom: aTagValue [
	
	"First element is the attribute description"
	elements ifEmpty: [ ^ LDAPString new ].

	^ LDAPAttributeValueSet new
]

{ #category : 'accessing' }
LDAPPartialAttribute >> values [

	^ elements second collect: #asString

]

{ #category : 'accessing' }
LDAPPartialAttribute >> values: aCollectionOfStrings [
	elements second removeAll.
	aCollectionOfStrings isString "a String is a collection, so don’t use isCollection here"
		ifFalse: [ aCollectionOfStrings do: [ :eachVal | self addValue: eachVal ] ]
		ifTrue: [ self addValue: aCollectionOfStrings ] .

]
