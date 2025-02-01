"
I am the grammar to match LDAP attributes syntax in the schema
"
Class {
	#name : 'LDAPSyntaxGrammar',
	#superclass : 'LDAPSchemaGrammar',
	#instVars : [
		'syntax'
	],
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'accessing' }
LDAPSyntaxGrammar >> start [

	^ syntax end
]

{ #category : 'accessing' }
LDAPSyntaxGrammar >> syntax [
"SyntaxDescription = LPAREN WSP
         numericoid                 ; object identifier
         [ SP ""DESC"" SP qdstring ]  ; description
         extensions WSP RPAREN      ; extensions"
	^ self parenthesesAround: (
		numericOid,
		description optional,
		extensions
	)
]
