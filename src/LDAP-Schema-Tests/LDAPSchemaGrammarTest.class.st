Class {
	#name : 'LDAPSchemaGrammarTest',
	#superclass : 'LDAPSchemaPrimitiveGrammarTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'accessing' }
LDAPSchemaGrammarTest >> parserClass [
	^ LDAPSchemaGrammar 
]

{ #category : 'tests' }
LDAPSchemaGrammarTest >> testDescription [ 

	self parse: ' DESC ''a string, hé''' rule: #description.
	self assert: result equals: 'a string, hé'.
	

]

{ #category : 'tests' }
LDAPSchemaGrammarTest >> testExtensions [ 

	self parse: ' X-ORIGIN ''RFC 4519''' rule: #extensions.
	self assert: result equals: { 'X-ORIGIN' -> #('RFC 4519') } asDictionary.
	
	self parse: ' X-A ( ''a1'' ''a2'' )' rule: #extensions.
	self assert: result equals: { 'X-A' -> #('a1' 'a2') } asDictionary.

	self parse: ' X-A ''a'' X-B ''b''' rule: #extensions.
	self assert: result equals: { 'X-A' -> #('a'). 'X-B' -> #('b') } asDictionary.
	

]

{ #category : 'tests' }
LDAPSchemaGrammarTest >> testNames [ 

	self parse: ' NAME ''top''' rule: #names.
	self assert: result equals: #('top').
	
	self parse: ' NAME (''a'' ''b'')' rule: #names.
	self assert: result equals: #( 'a' 'b' ).
	
	self parse: ' NAME ( ''a'' ''b'' )' rule: #names.
	self assert: result equals: #( 'a' 'b' ).
	
	self parse: ' NAME ( ''a'' ''b'')' rule: #names.
	self assert: result equals: #( 'a' 'b' ).
	
	self parse: ' NAME (''a'' ''b'' )' rule: #names.
	self assert: result equals: #( 'a' 'b' ).
	
	self fail: ' NAME (''a''  ''b'')' rule: #names.

]

{ #category : 'tests' }
LDAPSchemaGrammarTest >> testObsolete [ 

	self parse: ' OBSOLETE' rule: #obsolete.
	self assert: result.
]
