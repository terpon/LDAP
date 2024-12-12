"
I have the common rules for parsing different schema strings
"
Class {
	#name : 'LDAPSchemaGrammar',
	#superclass : 'LDAPSchemaPrimitiveGrammar',
	#instVars : [
		'names',
		'superiors',
		'description',
		'obsolete',
		'extensions'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'grammar' }
LDAPSchemaGrammar >> description [ 

	^ self elementNamed: 'DESC' as: qdstring
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> elementNamed: aString as: anObject [

	^ (self space, aString asPParser, self space, anObject) ==> #fourth
]

{ #category : 'accessing' }
LDAPSchemaGrammar >> extensions [
"*( SP xstring SP qdstrings )"
	| extension |
	extension := (self space, self xstring, self space, qdstrings)
		==> [ :tokens | tokens second -> tokens fourth ].
	^ extension star
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> flagNamed: aString [

	^ (self space, aString asPParser) ==> #second
]

{ #category : 'accessing' }
LDAPSchemaGrammar >> names [

	^ self elementNamed: 'NAME' as: qdescriptors
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> obsolete [ 

	^ self flagNamed: 'OBSOLETE'
]

{ #category : 'accessing' }
LDAPSchemaGrammar >> start [
"Not meant to be used directly, but the method is necessary for the tests"
	^ #epsilon asPParser
]

{ #category : 'accessing' }
LDAPSchemaGrammar >> superiors [ 

	^ self elementNamed: 'SUP' as: oids
]
