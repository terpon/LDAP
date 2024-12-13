"
I contain the schema description for LDAP entries
"
Class {
	#name : 'LDAPSchema',
	#superclass : 'Object',
	#instVars : [
		'objects',
		'objectClasses',
		'attributeSyntaxes',
		'attributeTypes',
		'logger'
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

	DefaultSchema := self new
		parseSyntaxes: LDAPSyntax defaultObjects;
		parseTypes: LDAPAttributeType defaultObjects;
		parseClasses: LDAPObjectClass defaultObjects;
		logger: LDAPSchemaInspectLogger new;
		build
]

{ #category : 'adding' }
LDAPSchema >> addObjectClass: anObject [

	objects add: anObject.
	objectClasses at: anObject oid put: anObject.
	anObject names do: [ :name | objectClasses at: name asLowercase put: anObject ].
]

{ #category : 'adding' }
LDAPSchema >> addSyntax: anObject [

	objects add: anObject.
	attributeSyntaxes at: anObject oid put: anObject.
]

{ #category : 'adding' }
LDAPSchema >> addType: anObject [

	objects add: anObject.
	attributeTypes at: anObject oid put: anObject.
	anObject names do: [ :name | attributeTypes at: name asLowercase put: anObject ].
]

{ #category : 'building' }
LDAPSchema >> build [
"Replace names and OIDs with actual objects"
	self logger reset.
	self pullAttributesProperties.
	self pullClassesProperties.
	self logger report; reset.
]

{ #category : 'initialization' }
LDAPSchema >> initialize [ 
	super initialize.
	
	objects := Set new.
	objectClasses := Dictionary new.
	attributeSyntaxes := Dictionary new.
	attributeTypes := Dictionary new.
]

{ #category : 'accessing' }
LDAPSchema >> logger [

	^ logger ifNil: [ logger := LDAPSchemaLogger new ]
]

{ #category : 'accessing' }
LDAPSchema >> logger: anObject [

	logger := anObject
]

{ #category : 'accessing' }
LDAPSchema >> objectClass: aString ifAbsent: aBlock [

	^ objectClasses at: aString asLowercase ifAbsent: aBlock
]

{ #category : 'parsing' }
LDAPSchema >> parseClasses: aCollection [

	| parser |
	parser := LDAPObjectClassParser new.
	aCollection do: [ :string |
		self addObjectClass: (parser parse: string)
	]
]

{ #category : 'parsing' }
LDAPSchema >> parseSyntaxes: aCollection [

	| parser |
	parser := LDAPSyntaxParser new.
	aCollection do: [ :string |
		self addSyntax: (parser parse: string)
	]
]

{ #category : 'parsing' }
LDAPSchema >> parseTypes: aCollection [

	| parser |
	parser := LDAPTypeParser new.
	aCollection do: [ :string |
		self addType: (parser parse: string)
	]
]

{ #category : 'building' }
LDAPSchema >> pullAttributes: aCollection for: aString in: anObject [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | self type: name 
		ifAbsent: [ logger missingAttribute: name for: aString in: anObject. name ]
	].
	^ set asSet asArray
]

{ #category : 'building' }
LDAPSchema >> pullAttributesProperties [
"Replace names and OIDs with actual objects"

	| set |
	set := attributeTypes values asSet.
	"First fix all sups"
	set do: [ :type | type superior ifNotNil: [ :sup | 
			type superior: (self type: sup 
				ifAbsent: [ logger missingAttribute: sup for: 'sup' in: type. sup ]) ] 
	].
	set do: [ :type | type pullProperties ].
	"Now syntax are there"
	set do: [ :type | type syntax: (self syntax: type syntax 
		ifAbsent: [ logger missingSyntax: type syntax in: type.  ]) 
	].
	

]

{ #category : 'building' }
LDAPSchema >> pullClassesProperties [
	"Replace names and OIDs with actual objects"

	| set |
	set := objectClasses values asSet.
	"First fix all sups"
	set do: [ :class |
		class superiors: (class superiors collect: [ :sup |
				 self objectClass: sup ifAbsent: [
					 logger missingClass: sup in: class.
					 sup ] ]) ].
	set do: [ :class | class pullProperties ].
	"Now all attributes are populated"
	set do: [ :class |
		class must: (self pullAttributes: class must for: 'must' in: class).
		class may: (self pullAttributes: class may for: 'may' in: class) ]
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
	objectClasses values asSet do: [ :class | types addAll: class must; addAll: class may ].
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

{ #category : 'accessing' }
LDAPSchema >> syntax: aString ifAbsent: aBlock [

	^ attributeSyntaxes at: aString ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> type: aString ifAbsent: aBlock [

	^ attributeTypes at: aString asLowercase ifAbsent: aBlock
]
