"
I represent the grammar of an object class definition
"
Class {
	#name : 'LDAPObjectClassGrammar',
	#superclass : 'LDAPSchemaGrammar',
	#instVars : [
		'objectClass',
		'superiors',
		'kind',
		'must',
		'may'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'accessing' }
LDAPObjectClassGrammar >> kind [ 

	^ (self space, ('ABSTRACT' asPParser / 'AUXILIARY' asPParser / 'STRUCTURAL' asPParser)) 
	==> [ :t | t second asLowercase asSymbol ]
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> may [ 

	^ self elementNamed: 'MAY' as: oids
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> must [ 

	^ self elementNamed: 'MUST' as: oids
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> objectClass [
" ObjectClassDescription = LPAREN WSP
         numericoid                 ; object identifier
         [ SP ""NAME"" SP qdescrs ]   ; short names (descriptors)
         [ SP ""DESC"" SP qdstring ]  ; description
         [ SP ""OBSOLETE"" ]          ; not active
         [ SP ""SUP"" SP oids ]       ; superior object classes
         [ SP kind ]                ; kind of class
         [ SP ""MUST"" SP oids ]      ; attribute types
         [ SP ""MAY"" SP oids ]       ; attribute types
         extensions WSP RPAREN
     kind = ""ABSTRACT"" / ""STRUCTURAL"" / ""AUXILIARY"""
	^ self parenthesesAround: (
		numericOid,
		names optional,
		description optional,
		obsolete,
		superiors optional,
		kind optional,
		must optional,
		may optional,
		extensions
	)
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> start [

	^ objectClass end
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> superiors [

	^ self elementNamed: 'SUP' as: oids
]
