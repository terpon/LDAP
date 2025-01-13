"
I report error in an inspector window
"
Class {
	#name : 'LDAPSchemaInspectLogger',
	#superclass : 'LDAPSchemaLogger',
	#instVars : [
		'attributes',
		'syntaxes',
		'classes',
		'duplicates'
	],
	#category : 'LDAP-Schema-Utilities',
	#package : 'LDAP-Schema',
	#tag : 'Utilities'
}

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> duplicate: aString in: aType [ 

	duplicates ifNil: [ duplicates := OrderedCollection new ].
	duplicates addLast: { ('Duplicate ', aType) . aString }
]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingAttribute: aString for: aMember in: anObject [ 

	| pair |
	pair := { aMember . anObject }.
	attributes at: aString update: [ :value | value add: pair; yourself ] initial: [ OrderedCollection with: pair ].	


]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingClass: aString in: anObject [ 

	classes at: aString update: [ :value | value add: anObject; yourself ] initial: [ OrderedCollection with: anObject ].

]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingSyntax: aString in: anObject [ 

	syntaxes at: aString update: [ :value | value add: anObject; yourself ] initial: [ OrderedCollection with: anObject ].

]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> report [
	
	^ (Array streamContents: [ :stream |
			syntaxes keysAndValuesDo: [ :syntax :elements | stream nextPut: { 'Missing syntax'. syntax . elements asArray } ].
			classes keysAndValuesDo: [ :class :elements | stream nextPut: { 'Missing objectClass'. class . elements asArray } ].
			attributes keysAndValuesDo: [ :attr :elements | stream nextPut: { 'Missing attribute'. attr . elements asArray } ].
			duplicates do: [ :pair | stream nextPut: pair ]
		]) ifNotEmpty: [ :logs | logs inspect; yourself ].
]

{ #category : 'initialization' }
LDAPSchemaInspectLogger >> reset [

	attributes := Dictionary new.
	syntaxes := Dictionary new.
	classes := Dictionary new.
]
