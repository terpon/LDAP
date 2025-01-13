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
	#category : 'LDAP-Schema-Utilities',
	#package : 'LDAP-Schema',
	#tag : 'Utilities'
}

{ #category : 'building' }
LDAPSchemaBuilder >> build [
"Replace names and OIDs with actual objects"

	self logger reset.
	self replaceAttributesProperties.
	self replaceClassesProperties.
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
LDAPSchemaBuilder >> pullAttributeEquality: anAttribute [

	| sup eq |
	anAttribute equality ifNotNil: [ :value | ^ value ].
	sup := anAttribute superior ifNil: [ ^ nil ].
	eq := self pullAttributeEquality: sup.
	anAttribute equality: eq.
	^ eq
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullAttributeOrdering: anAttribute [

	| sup order |
	anAttribute ordering ifNotNil: [ :value | ^ value ].
	sup := anAttribute superior ifNil: [ ^ nil ].
	order := self pullAttributeOrdering: sup.
	anAttribute ordering: order.
	^ order
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullAttributeSubstring: anAttribute [

	| sup substr |
	anAttribute substring ifNotNil: [ :value | ^ value ].
	sup := anAttribute superior ifNil: [ ^ nil ].
	substr := self pullAttributeSubstring: sup.
	anAttribute substring: substr.
	^ substr
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullAttributeSyntax: anAttribute [

	| pair |
	anAttribute syntax ifNotNil: [ ^ { anAttribute syntax. anAttribute syntaxLength } ].
	
	"If syntax nil recurse to superior (should not be nil in that case)"
	pair := self pullAttributeSyntax: anAttribute superior.
	anAttribute syntax: pair first.	
	anAttribute syntaxLength: pair second.	
	^ pair
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullMayAttributes: anObjectClass [

	| may |
	may := anObjectClass superiors collect: [ :sup | self pullMayAttributes: sup ].
	may := may flattened asSet.
	may addAll: anObjectClass may.
	anObjectClass may: may.
	^ may
]

{ #category : 'building' }
LDAPSchemaBuilder >> pullMustAttributes: anObjectClass [

	| must |
	must := anObjectClass superiors collect: [ :sup | self pullMustAttributes: sup ].
	must := must flattened asSet.
	must addAll: anObjectClass must.
	anObjectClass must: must.
	^ must
]

{ #category : 'building' }
LDAPSchemaBuilder >> replaceAttributesProperties [
"Replace names and OIDs with actual objects"

	"First fix all sups"
	types do: [ :type | type superior ifNotNil: [ :sup | 
			type superior: (schema type: sup 
				ifAbsent: [ logger missingAttribute: sup for: 'sup' in: type. sup ]) ] 
	].
	"Pull properties from superiors if needed"
	types do: [ :type | self 
		pullAttributeSyntax: type;
		pullAttributeEquality: type;
		pullAttributeOrdering: type;
		pullAttributeSubstring: type.
	].
	"Now syntax are there"
	types do: [ :type | | stringSyntax |
		stringSyntax := type syntax.
		type syntax: (schema syntax: stringSyntax 
			ifAbsent: [ logger missingSyntax: stringSyntax in: type. stringSyntax ]) 
	].
]

{ #category : 'building' }
LDAPSchemaBuilder >> replaceClassAttributes: aCollection for: aString in: anObject [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | schema type: name 
		ifAbsent: [ logger missingAttribute: name for: aString in: anObject. LDAPAttributeType unknownNamed: name. ]
	].
	^ set sorted
]

{ #category : 'building' }
LDAPSchemaBuilder >> replaceClasses: aCollection for: aString in: anObject [
"Replace names and OIDs with actual objects"

	| set |
	set := aCollection collect: [ :name | schema objectClass: name 
		ifAbsent: [ logger missingClass: name in: anObject. LDAPObjectClass unknownNamed: name. ]
	].
	^ set asSet asArray
]

{ #category : 'building' }
LDAPSchemaBuilder >> replaceClassesProperties [
	"Replace names and OIDs with actual objects"

	"First fix all sups"
	classes do: [ :class |
		class superiors: (self replaceClasses: class superiors for: 'superiors' in: class).
		class containment: (self replaceClasses: class containment for: 'containment' in: class).
	].
	"Pull inherited attributes from superiors"
	classes do: [ :class | self
		pullMustAttributes: class;
		pullMayAttributes: class.
	].
	"Now all attributes are populated"
	classes do: [ :class |
		class must: (self replaceClassAttributes: class must for: 'must' in: class).
		class may: (self replaceClassAttributes: class may for: 'may' in: class).
		class naming: (self replaceClassAttributes: class naming for: 'naming' in: class).
	].
]
