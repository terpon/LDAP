"
I parse the grammar for attribute types in the directory schema
"
Class {
	#name : 'LDAPTypeGrammar',
	#superclass : 'LDAPSchemaGrammar',
	#instVars : [
		'type',
		'superior',
		'equality',
		'ordering',
		'substr',
		'syntax',
		'singleValue',
		'collective',
		'noUserModification',
		'usage',
		'noidlen'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'grammar' }
LDAPTypeGrammar >> collective [ 

	^ self flagNamed: 'COLLECTIVE'
]

{ #category : 'grammar' }
LDAPTypeGrammar >> equality [

	^ self elementNamed: 'EQUALITY' as: oid
]

{ #category : 'grammar' }
LDAPTypeGrammar >> noUserModification [ 

	^ self flagNamed: 'NO-USER-MODIFICATION'
]

{ #category : 'accessing' }
LDAPTypeGrammar >> noidlen [
"noidlen = numericoid [ LCURLY len RCURLY ]"
	| len |
	len := (${ asPParser, number, $} asPParser) ==> #second.
	^ numericOid, len optional
]

{ #category : 'grammar' }
LDAPTypeGrammar >> ordering [

	^ self elementNamed: 'ORDERING' as: oid
]

{ #category : 'grammar' }
LDAPTypeGrammar >> singleValue [ 

	^ self flagNamed: 'SINGLE-VALUE'
]

{ #category : 'accessing' }
LDAPTypeGrammar >> start [

	^ type end
]

{ #category : 'grammar' }
LDAPTypeGrammar >> substr [

	^ self elementNamed: 'SUBSTR' as: oid
]

{ #category : 'accessing' }
LDAPTypeGrammar >> superior [ 

	^ self elementNamed: 'SUP' as: oid
]

{ #category : 'grammar' }
LDAPTypeGrammar >> syntax [

	^ self elementNamed: 'SYNTAX' as: noidlen
]

{ #category : 'grammar' }
LDAPTypeGrammar >> type [
"AttributeTypeDescription = LPAREN WSP
         numericoid                    ; object identifier
         [ SP ""NAME"" SP qdescrs ]      ; short names (descriptors)
         [ SP ""DESC"" SP qdstring ]     ; description
         [ SP ""OBSOLETE"" ]             ; not active
         [ SP ""SUP"" SP oid ]           ; supertype
         [ SP ""EQUALITY"" SP oid ]      ; equality matching rule
         [ SP ""ORDERING"" SP oid ]      ; ordering matching rule
         [ SP ""SUBSTR"" SP oid ]        ; substrings matching rule
         [ SP ""SYNTAX"" SP noidlen ]    ; value syntax
         [ SP ""SINGLE-VALUE"" ]         ; single-value
         [ SP ""COLLECTIVE"" ]           ; collective
         [ SP ""NO-USER-MODIFICATION"" ] ; not user modifiable
         [ SP ""USAGE"" SP usage ]       ; usage
         extensions WSP RPAREN         ; extensions "
	^ self parenthesesAround: (
		numericOid,
		names optional,
		description optional,
		obsolete,
		superior optional,
		equality optional,
		ordering optional,
		substr optional,
		syntax optional,
		singleValue,
		collective,
		noUserModification,
		usage optional,
		extensions
	)
]

{ #category : 'grammar' }
LDAPTypeGrammar >> usage [
"[ SP ""USAGE"" SP usage ]
     usage = ""userApplications""     /  ; user
             ""directoryOperation""   /  ; directory operational
             ""distributedOperation"" /  ; DSA-shared operational
             ""dSAOperation""            ; DSA-specific operational"
	^ (self space, 'USAGE' asPParser, self space, (
			'userApplications' asPParser / 
			'directoryOperation' asPParser / 
			'distributedOperation' asPParser /
			'dSAOperation' asPParser
		) ) ==> [ :t | t fourth asSymbol ]
]
