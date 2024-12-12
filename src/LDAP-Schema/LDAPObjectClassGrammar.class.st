Class {
	#name : 'LDAPObjectClassGrammar',
	#superclass : 'LDAPSchemaGrammar',
	#instVars : [
		'objectClass',
		'names',
		'description',
		'obsolete',
		'kind',
		'must',
		'may',
		'extensions',
		'superiors'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'accessing' }
LDAPObjectClassGrammar >> description [ 

	^ self elementNamed: 'DESC' as: qdstring
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> extensions [
"*( SP xstring SP qdstrings )"
	| extension |
	extension := (self space, self xstring, self space, qdstrings)
		==> [ :tokens | tokens second -> tokens fourth ].
	^ extension star
]

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
LDAPObjectClassGrammar >> names [

	^ self elementNamed: 'NAME' as: qdescriptors
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
		obsolete optional,
		superiors optional,
		kind optional,
		must optional,
		may optional,
		extensions
	)
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> obsolete [ 

	^ (self space, 'OBSOLETE' asPParser) ==> #second
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> start [

	^ objectClass end
]

{ #category : 'accessing' }
LDAPObjectClassGrammar >> superiors [ 

	^ self elementNamed: 'SUP' as: oids
]
