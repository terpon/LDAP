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

	DefaultSchema := self new
		parseSyntaxes: LDAPSyntax defaultObjects;
		parseTypes: LDAPAttributeType defaultObjects;
		parseClasses: LDAPObjectClass defaultObjects;
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

	self pullAttributesProperties.
	self pullClassesProperties.
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
LDAPSchema >> pullAttributesFor: aCollection [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | self type: name ifAbsent: [ name ] ].
	^ set asSet asArray
]

{ #category : 'building' }
LDAPSchema >> pullAttributesProperties [
"Replace names and OIDs with actual objects"

	| set |
	set := attributeTypes values asSet.
	"First fix all sups"
	set do: [ :type | type superior ifNotNil: [ :sup | type superior: (self type: sup ifAbsent: [ self error: 'Unknown attribute']) ] ].
	set do: [ :type | type pullProperties ].
	"Now syntax are there"
	set do: [ :type | type syntax: (self syntax: type syntax 
		ifAbsent: [ type names first trace. ' - Unknown syntax ' trace. type syntax traceCr ]) ].
	

]

{ #category : 'building' }
LDAPSchema >> pullClassesProperties [
"Replace names and OIDs with actual objects"

	| set |
	set := objectClasses values asSet.
	"First fix all sups"
	set do: [ :class | class superiors: (class superiors collect: [ :sup | self objectClass: sup ifAbsent: [ self error: 'Unknow class ', sup ]  ]) ].
	set do: [ :class | class pullProperties ].
	"Now all attributes are populated"
	set do: [ :class | 
			class must: (self pullAttributesFor: class must).
			class may: (self pullAttributesFor: class may). 
	].
	

]

{ #category : 'accessing' }
LDAPSchema >> syntax: aString ifAbsent: aBlock [

	^ attributeSyntaxes at: aString ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> type: aString ifAbsent: aBlock [

	^ attributeTypes at: aString asLowercase ifAbsent: aBlock
]
