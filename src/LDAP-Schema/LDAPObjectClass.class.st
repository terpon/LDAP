"
I represent an object class
"
Class {
	#name : 'LDAPObjectClass',
	#superclass : 'LDAPObject',
	#instVars : [
		'names',
		'description',
		'obsolete',
		'superiors',
		'must',
		'may',
		'kind'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'accessing' }
LDAPObjectClass >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPObjectClass >> description: anObject [

	description := anObject
]

{ #category : 'accessing - extension' }
LDAPObjectClass >> extensions: aDictionary [
	"No extensions managed here"
]

{ #category : 'accessing' }
LDAPObjectClass >> kind [

	^ kind ifNil: [ #structural ]
]

{ #category : 'accessing' }
LDAPObjectClass >> kind: anObject [

	kind := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> may [

	^ may ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> may: anObject [

	may := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> must [

	^ must ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> must: anObject [

	must := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> names [

	^ names ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> names: anObject [

	names := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> obsolete [

	^ obsolete ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPObjectClass >> obsolete: anObject [

	obsolete := anObject
]

{ #category : 'printing' }
LDAPObjectClass >> printOn: aStream [

	aStream nextPutAll: 'a '; nextPutAll: self className; space.
	self names size = 1
		ifTrue: [ aStream nextPutAll: names first ] 
		ifFalse: [ self names printElementsOn: aStream ].
	aStream nextPutAll: ' ('; nextPutAll: oid; nextPut: $).
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors [

	^ superiors 	ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors: anObject [

	superiors := anObject
]
