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
