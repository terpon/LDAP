"
I represent an object class
"
Class {
	#name : 'LDAPObjectClass',
	#superclass : 'Object',
	#instVars : [
		'oid',
		'names',
		'description',
		'obsolete',
		'superiors',
		'must',
		'may',
		'kind',
		'extensions'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'comparing' }
LDAPObjectClass >> = anObject [

	^ oid = anObject oid
]

{ #category : 'accessing' }
LDAPObjectClass >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPObjectClass >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> extensions [

	^ extensions ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> extensions: anObject [

	extensions := anObject
]

{ #category : 'comparing' }
LDAPObjectClass >> hash [

	^ oid hash
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

{ #category : 'accessing' }
LDAPObjectClass >> oid [

	^ oid
]

{ #category : 'accessing' }
LDAPObjectClass >> oid: anObject [

	oid := anObject
]

{ #category : 'printing' }
LDAPObjectClass >> printOn: aStream [

	super printOn: aStream.
	aStream space; nextPutAll: oid; space.
	self names size = 1
		ifTrue: [ aStream nextPutAll: names first ] 
		ifFalse: [ self names printElementsOn: aStream ] 
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors [

	^ superiors 	ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors: anObject [

	superiors := anObject
]
