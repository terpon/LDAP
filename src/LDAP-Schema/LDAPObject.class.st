"
I am the base class for schema objects that have a unique object identifien OID
"
Class {
	#name : 'LDAPObject',
	#superclass : 'Object',
	#instVars : [
		'oid',
		'description',
		'obsolete'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'comparing' }
LDAPObject >> = anObject [
	
	anObject ifNil: [ ^ false ].
	^ oid = anObject oid
]

{ #category : 'converting' }
LDAPObject >> asString [

	^ self name
]

{ #category : 'extensions' }
LDAPObject >> checkSupport: aCollection in: aDictionary [

	aDictionary keys asSet removeAllFoundIn: aCollection; ifNotEmpty: [ :set |
		| extra |
		extra := String streamContents: [ :s | set printElementsOn: s ].
		self error: 'Extensions not supported: ', extra
	].
]

{ #category : 'accessing' }
LDAPObject >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPObject >> description: anObject [

	description := anObject
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

{ #category : 'converting' }
LDAPObject >> name [

	^ oid asString
]

{ #category : 'accessing' }
LDAPObject >> obsolete [

	^ obsolete ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPObject >> obsolete: anObject [

	obsolete := anObject
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

	aStream 
		nextPutAll: 'a '; nextPutAll: self className;
		nextPutAll: ' ('; nextPutAll: oid; nextPut: $).
]
