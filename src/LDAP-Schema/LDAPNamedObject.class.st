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

{ #category : 'converting' }
LDAPNamedObject >> asString [ 

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

	aStream nextPutAll: 'a '; nextPutAll: self className; space.
	self names size = 1
		ifTrue: [ aStream nextPutAll: names first ] 
		ifFalse: [ self names printElementsOn: aStream ].
	aStream nextPutAll: ' ('; nextPutAll: oid; nextPut: $).
]
