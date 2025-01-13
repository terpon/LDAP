"
I am a converter class to transform data returned by a LDAP server to a LDAPSchema instance
"
Class {
	#name : 'LDAPSchemaBuilder',
	#superclass : 'Object',
	#instVars : [
		'logger',
		'schema',
		'classes',
		'types',
		'syntaxes'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'building' }
LDAPSchemaBuilder >> build [
"Replace names and OIDs with actual objects"

	self logger reset.
	self pullAttributesProperties.
	self pullClassesProperties.
	schema structuralClasses: (classes select: #isStructural).
	self logger report; reset.
	
	^ schema
]

{ #category : 'initialization' }
LDAPSchemaBuilder >> initialize [ 

	super initialize.
	
	schema := LDAPSchema new.
	classes := Set new.
	types := Set new.
	syntaxes := Set new.
]

{ #category : 'accessing' }
LDAPSchemaBuilder >> logger [

	^ logger ifNil: [ logger := LDAPSchemaLogger new ]
]

{ #category : 'accessing' }
LDAPSchemaBuilder >> logger: anObject [

	logger := anObject
]

{ #category : 'parsing' }
LDAPSchemaBuilder >> parseClasses: aCollection [

	| parser |
	parser := LDAPObjectClassParser new.
	aCollection do: [ :string | | class |
		class := parser parse: string.
		(classes includes: class) ifTrue: [ logger duplicate: class name in: 'Object Class' ]
			 ifFalse: [ 
				classes add: class.
				schema addObjectClass: class
			 ]
	]
]

{ #category : 'parsing' }
LDAPSchemaBuilder >> parseSyntaxes: aCollection [

	| parser |
	parser := LDAPSyntaxParser new.
	aCollection do: [ :string | | syntax |
		syntax := parser parse: string.
		(classes includes: syntax) ifTrue: [ logger duplicate: syntax name in: 'Syntax' ]
			 ifFalse: [ 
				syntaxes add: syntax.
				schema addSyntax: syntax
			 ]
	]
]

{ #category : 'parsing' }
LDAPSchemaBuilder >> parseTypes: aCollection [

	| parser |
	parser := LDAPTypeParser new.
	aCollection do: [ :string | | type |
		type := parser parse: string.
		(classes includes: type) ifTrue: [ logger duplicate: type name in: 'Attribute Type' ]
			 ifFalse: [ 
				types add: type.
				schema addType: type
			 ]
	]
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullAttributes: aCollection for: aString in: anObject [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | schema type: name 
		ifAbsent: [ logger missingAttribute: name for: aString in: anObject. LDAPAttributeType unknownNamed: name. ]
	].
	^ set asSet asArray
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullAttributesProperties [
"Replace names and OIDs with actual objects"

	"First fix all sups"
	types do: [ :type | type superior ifNotNil: [ :sup | 
			type superior: (schema type: sup 
				ifAbsent: [ logger missingAttribute: sup for: 'sup' in: type. sup ]) ] 
	].
	types do: [ :type | type pullProperties ].
	"Now syntax are there"
	types do: [ :type | | stringSyntax |
		stringSyntax := type syntax.
		type syntax: (schema syntax: stringSyntax 
			ifAbsent: [ logger missingSyntax: stringSyntax in: type. stringSyntax ]) 
	].
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullClasses: aCollection for: aString in: anObject [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | schema objectClass: name 
		ifAbsent: [ logger missingClass: name in: anObject. LDAPObjectClass unknownNamed: name. ]
	].
	^ set asSet asArray
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullClassesProperties [
	"Replace names and OIDs with actual objects"

	"First fix all sups"
	classes do: [ :class |
		class superiors: (self pullClasses: class superiors for: 'superiors' in: class).
		class containment: (self pullClasses: class containment for: 'containment' in: class).
	].
	"Pull inherited attributes from superiors"
	classes do: [ :class | class pullProperties ].
	"Now all attributes are populated"
	classes do: [ :class |
		class must: (self pullAttributes: class must for: 'must' in: class).
		class may: (self pullAttributes: class may for: 'may' in: class).
		class naming: (self pullAttributes: class naming for: 'naming' in: class).
	].
]
