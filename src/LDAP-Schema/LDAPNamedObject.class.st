"
I am the common base class for schema objects with names
"
Class {
	#name : 'LDAPNamedObject',
	#superclass : 'LDAPObject',
	#instVars : [
		'names'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'instance creation' }
LDAPNamedObject class >> unknownNamed: aString [

	^ self new names: { aString }; oid: 'UNKNOWN'; yourself 
]

{ #category : 'comparing' }
LDAPNamedObject >> <= anObject [

	^	self name caseInsensitiveLessOrEqual: anObject name
]

{ #category : 'accessing' }
LDAPNamedObject >> displayName [

	| list |
	list := self names ifEmpty: [ ^ self name ].
	list size = 1 ifTrue: [ ^ names first ].
	
	^ String streamContents: [ :stream |
		stream nextPutAll: list first; nextPutAll: ' ('.
		list allButFirst do: [ :name | stream nextPutAll: name ] separatedBy: [ stream nextPutAll: ', ' ].
		stream nextPut: $)
	]
]

{ #category : 'accessing' }
LDAPNamedObject >> keys [
"Returns all the ways the object can be referenced"
	^ self names copyWith: self oid asString
]

{ #category : 'enumerating' }
LDAPNamedObject >> keysDo: aBlock [

	self names do: aBlock.
	aBlock value: self oid.
]

{ #category : 'converting' }
LDAPNamedObject >> name [

	^ names isEmptyOrNil ifTrue: [ super asString ] ifFalse: [ names first asString ]
]

{ #category : 'accessing' }
LDAPNamedObject >> names [

	^ names ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPNamedObject >> names: anObject [

	names := anObject
]

{ #category : 'printing' }
LDAPNamedObject >> printOn: aStream [

	aStream 
		nextPutAll: 'a '; nextPutAll: self className; 
		space; 
		nextPutAll: self displayName;
		space;
		nextPutAll: oid.
]

{ #category : 'comparing' }
LDAPNamedObject >> sameAs: aString [
	"Case insensitive equality against any name, interface compatibility with String>>sameAs:"
	^ self names anySatisfy: [ :name | name sameAs: aString ]
]
