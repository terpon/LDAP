"
I contain the grammar rules for the primitive types of the LDAP schema
"
Class {
	#name : 'LDAPSchemaPrimitiveGrammar',
	#superclass : 'PP2CompositeNode',
	#instVars : [
		'number',
		'lparen',
		'rparen',
		'dollar',
		'descriptor',
		'qdescriptors',
		'qdstring',
		'qdstrings',
		'numericOid',
		'oid',
		'oids'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> descriptor [

	^ (#letter asPParser, (#letter asPParser / #digit asPParser / $- asPParser) star) flatten
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> dollar [

	^ (self wspace, $$ asPParser, self wspace) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> dstring [

	^ (self qs / self qq / self qutf8) plus flatten
]

{ #category : 'grammar - helper' }
LDAPSchemaPrimitiveGrammar >> listOf: anObject separatedBy: aSeparator [
" qdescrs = qdescr / ( LPAREN WSP qdescrlist WSP RPAREN )
  qdescrlist = [ qdescr *( SP qdescr ) ]
  qdescr = SQUOTE descr SQUOTE"
	| single following list |
	single := (anObject ==> [:t | {t}]).
	following := (aSeparator, anObject) ==> #second.
	list := (anObject , following star) ==> [ :tokens | { tokens first}, tokens second ].
	^ single / (self parenthesesAround: list)
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> lparen [

	^ ($( asPParser, self wspace) ==> #first
]

{ #category : 'accessing' }
LDAPSchemaPrimitiveGrammar >> number [

	^ ($0 asPParser / #digit asPParser plus) flatten ==> #asInteger
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> numericOid [

	^ (#digit asPParser, (#digit asPParser / $. asPParser) star) flatten
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> oid [

	^ numericOid / descriptor
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> oids [

	^ 	self listOf: oid separatedBy: dollar
]

{ #category : 'grammar - helper' }
LDAPSchemaPrimitiveGrammar >> parenthesesAround: anObject [

	^ (lparen, anObject, rparen) ==> #second
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> qdescriptor [

	^ self quotesAround: descriptor
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> qdescriptors [

	^ self listOf: self qdescriptor separatedBy: self space
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> qdstring [

	^ self quotesAround: self dstring
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> qdstrings [

	^ self listOf: qdstring separatedBy: self space
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> qq [

	^ '\27' asPParser ==> $\
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> qs [

	^ ('\5' asPParser, ($c asPParser / $C asPParser)) ==> $'
]

{ #category : 'grammar - helper' }
LDAPSchemaPrimitiveGrammar >> quotesAround: anObject [

	^ (self squote, anObject, self squote) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> qutf8 [

	^ PP2PredicateObjectNode noneOf: '\'''
]

{ #category : 'grammar' }
LDAPSchemaPrimitiveGrammar >> rparen [

	^ (self wspace, $) asPParser ) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> space [

	^ Character space asPParser
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> squote [

	^ $' asPParser 
]

{ #category : 'accessing' }
LDAPSchemaPrimitiveGrammar >> start [
"Not meant to be used directly, but the method is necessary for the tests"
	^ #epsilon asPParser
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> wspace [

	^ self space optional
]

{ #category : 'grammar - primitives' }
LDAPSchemaPrimitiveGrammar >> xstring [
"X HYPHEN 1*( ALPHA / HYPHEN / USCORE )"
	^ ('X-' asPParser, (#letter asPParser / $_ asPParser / $- asPParser) star) flatten
]
