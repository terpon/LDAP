"
I am the base class for schema objects that have a unique object identifien OID
"
Class {
	#name : 'LDAPObject',
	#superclass : 'Object',
	#instVars : [
		'oid'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'comparing' }
LDAPObject >> = anObject [

	^ oid = anObject oid
]

{ #category : 'accessing - extension' }
LDAPObject >> extensions: aDictionary [

	"Just delegate"
	self subclassResponsibility
]

{ #category : 'comparing' }
LDAPObject >> hash [

	^ oid hash
]

{ #category : 'accessing' }
LDAPObject >> oid [

	^ oid
]

{ #category : 'accessing' }
LDAPObject >> oid: anObject [

	oid := anObject
]

{ #category : 'printing' }
LDAPObject >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPutAll: 'a '; nextPutAll: self className;
		nextPutAll: ' ('; nextPutAll: oid; nextPut: $).
]
