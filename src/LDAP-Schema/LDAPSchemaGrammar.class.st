Class {
	#name : 'LDAPSchemaGrammar',
	#superclass : 'PP2CompositeNode',
	#instVars : [
		'lparen',
		'rparen',
		'dollar',
		'descriptor',
		'qdescriptors',
		'qdstring',
		'qdstrings',
		'oids',
		'numericOid',
		'oid'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'grammar' }
LDAPSchemaGrammar >> descriptor [

	^ (#letter asPParser, (#letter asPParser / #digit asPParser / $- asPParser) star) flatten
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> dollar [

	^ (self wspace, $$ asPParser, self wspace) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> dstring [

	^ (self qs / self qq / self qutf8) plus flatten
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> elementNamed: aString as: anObject [

	^ (self space, aString asPParser, self space, anObject) ==> #fourth
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> listOf: anObject separatedBy: aSeparator [
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
LDAPSchemaGrammar >> lparen [

	^ ($( asPParser, self wspace) ==> #first
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> numericOid [

	^ (#digit asPParser, (#digit asPParser / $. asPParser) star) flatten
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> oid [

	^ numericOid / descriptor
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> oids [

	^ 	self listOf: oid separatedBy: dollar
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> parenthesesAround: anObject [

	^ (lparen, anObject, rparen) ==> #second
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> qdescriptor [

	^ self quotesAround: descriptor
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> qdescriptors [

	^ self listOf: self qdescriptor separatedBy: self space
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> qdstring [

	^ self quotesAround: self dstring
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> qdstrings [

	^ self listOf: qdstring separatedBy: self space
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> qq [

	^ '\27' asPParser ==> $\
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> qs [

	^ ('\5' asPParser, ($c asPParser / $C asPParser)) ==> $'
]

{ #category : 'grammar - helper' }
LDAPSchemaGrammar >> quotesAround: anObject [

	^ (self squote, anObject, self squote) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> qutf8 [

	^ PP2PredicateObjectNode noneOf: '\'''
]

{ #category : 'grammar' }
LDAPSchemaGrammar >> rparen [

	^ (self wspace, $) asPParser ) ==> #second
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> space [

	^ Character space asPParser
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> squote [

	^ $' asPParser 
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> wspace [

	^ self space optional
]

{ #category : 'grammar - primitives' }
LDAPSchemaGrammar >> xstring [
"X HYPHEN 1*( ALPHA / HYPHEN / USCORE )"
	^ ('X-' asPParser, (#letter asPParser / $_ asPParser / $- asPParser) star) flatten
]
