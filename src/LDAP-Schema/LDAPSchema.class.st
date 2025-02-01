"
I contain the schema description for LDAP entries
"
Class {
	#name : 'LDAPSchema',
	#superclass : 'Object',
	#instVars : [
		'objectClasses',
		'structuralClasses',
		'attributeSyntaxes',
		'attributeTypes'
	],
	#classVars : [
		'DefaultSchema'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'accessing' }
LDAPSchema class >> default [

	^ DefaultSchema
]

{ #category : 'class initialization' }
LDAPSchema class >> initialize [ 

	DefaultSchema := LDAPSchemaBuilder new
		parseSyntaxes: LDAPSyntax defaultObjects;
		parseTypes: LDAPAttributeType defaultObjects;
		parseClasses: LDAPObjectClass defaultObjects;
		"logger: LDAPSchemaInspectLogger new;"
		build
]

{ #category : 'adding' }
LDAPSchema >> addObjectClass: anObject [

	objectClasses at: anObject oid put: anObject.
	anObject names do: [ :name | objectClasses at: name asLowercase put: anObject ].
]

{ #category : 'adding' }
LDAPSchema >> addSyntax: anObject [

	attributeSyntaxes at: anObject oid put: anObject.
]

{ #category : 'adding' }
LDAPSchema >> addType: anObject [

	attributeTypes at: anObject oid put: anObject.
	anObject names do: [ :name | attributeTypes at: name asLowercase put: anObject ].
]

{ #category : 'initialization' }
LDAPSchema >> initialize [ 
	super initialize.
	
	objectClasses := Dictionary new.
	attributeSyntaxes := Dictionary new.
	attributeTypes := Dictionary new.
]

{ #category : 'accessing' }
LDAPSchema >> objectClass: aString ifAbsent: aBlock [

	^ objectClasses at: aString asLowercase ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> objectClass: aString ifPresent: aPresentBlock ifAbsent: aBlock [

	^ objectClasses at: aString asLowercase ifPresent: aPresentBlock ifAbsent: aBlock
]

{ #category : 'enumerating' }
LDAPSchema >> referencedSyntaxes [

	| syntaxes all |
	syntaxes := attributeTypes values asSet collect: #syntax.
	all := attributeSyntaxes values asSet.

	^ { syntaxes. all removeAllFoundIn: syntaxes; yourself }
]

{ #category : 'enumerating' }
LDAPSchema >> referencedTypes [

	| types all |
	types := Set new.
	objectClasses values asSet do: [ :class | types 
		addAll: (class must reject: #isString); 
		addAll: (class may reject: #isString) 
	].
	types addAll: (attributeTypes values asSet collect: [ :attr | attr superior ] thenSelect: #isNotNil).
	all := attributeTypes values asSet.

	^ { types. all removeAllFoundIn: types; yourself }
]

{ #category : 'enumerating' }
LDAPSchema >> references: aType [

	| type |
	type := aType isString ifFalse: [ aType ] ifTrue: [ self type: aType ifAbsent: [ self error: 'No such attribute type'. ^ #() ] ].
	^ Array streamContents: [ :stream |
		objectClasses values asSet do: [ :class | 
			((class must includes: type) or: [class may includes: type])
				ifTrue: [ stream nextPut: class ] 
		] 
	]
]

{ #category : 'enumerating' }
LDAPSchema >> rejectKnownClasses: aCollection [

	^ aCollection reject: [ :each | objectClasses includesKey: each ]
]

{ #category : 'accessing' }
LDAPSchema >> structuralClasses [

	^ structuralClasses ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPSchema >> structuralClasses: aCollection [

	structuralClasses := aCollection
]

{ #category : 'accessing' }
LDAPSchema >> syntax: aString ifAbsent: aBlock [

	^ attributeSyntaxes at: aString ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> type: aString ifAbsent: aBlock [

	^ attributeTypes at: aString asLowercase ifAbsent: aBlock
]
