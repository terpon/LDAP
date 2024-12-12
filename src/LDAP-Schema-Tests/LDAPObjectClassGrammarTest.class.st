Class {
	#name : 'LDAPObjectClassGrammarTest',
	#superclass : 'PP2CompositeNodeTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'accessing' }
LDAPObjectClassGrammarTest >> parserClass [
	^ LDAPObjectClassGrammar 
]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testDescription [ 

	self parse: ' DESC ''a string, hé''' rule: #description.
	self assert: result equals: 'a string, hé'.
	

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testExtensions [ 

	self parse: ' X-ORIGIN ''RFC 4519''' rule: #extensions.
	self assert: result asArray equals: { 'X-ORIGIN' -> #('RFC 4519') }.
	
	self parse: ' X-A ( ''a1'' ''a2'' )' rule: #extensions.
	self assert: result asArray equals: { 'X-A' -> #('a1' 'a2') }.

	self parse: ' X-A ''a'' X-B ''b''' rule: #extensions.
	self assert: result asArray equals: { 'X-A' -> #('a'). 'X-B' -> #('b') }.
	

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testKind [ 

	self parse: ' ABSTRACT' rule: #kind.
	self assert: result equals: #abstract.
	
	self parse: ' AUXILIARY' rule: #kind.
	self assert: result equals: #auxiliary.
	
	self parse: ' STRUCTURAL' rule: #kind.
	self assert: result equals: #structural.
]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testMay [ 

	self parse: ' MAY ref' rule: #may.
	self assert: result equals: #('ref').

	self parse: ' MAY (cn$sn)' rule: #may.
	self assert: result equals: #('cn' 'sn').

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testMust [ 

	self parse: ' MUST objectClass' rule: #must.
	self assert: result equals: #('objectClass').

	self parse: ' MUST ( cn $ sn )' rule: #must.
	self assert: result equals: #('cn' 'sn').

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testNames [ 

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
LDAPObjectClassGrammarTest >> testObjectClass [ 

	self fail: '(what)' rule: #objectClass.
	self parse: self top rule: #objectClass.
	self assert: result equals: { '2.5.6.0'. #('top') . 'top of the superclass chain'. nil. nil. #abstract . #('objectClass'). nil . OrderedCollection empty }.
	

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testObsolete [ 

	self parse: ' OBSOLETE' rule: #obsolete.
	self assert: result equals: true.

]

{ #category : 'tests' }
LDAPObjectClassGrammarTest >> testSuperiors [ 

	self parse: ' SUP top' rule: #superiors.
	self assert: result equals: #('top').
	self parse: ' SUP 2.5.6.0' rule: #superiors.
	self assert: result equals: #('2.5.6.0').

	self parse: ' SUP (a $ b)' rule: #superiors.
	self assert: result equals: #( 'a' 'b' ).
	self parse: ' SUP (a$b)' rule: #superiors.
	self assert: result equals: #( 'a' 'b' ).
	
	self parse: ' SUP (1.2$3.4)' rule: #superiors.
	self assert: result equals: #( '1.2' '3.4' ).
	self parse: ' SUP (1.2$s$3.4)' rule: #superiors.
	self assert: result equals: #( '1.2' 's' '3.4' ).

]

{ #category : 'accessing' }
LDAPObjectClassGrammarTest >> top [

	^ '( 2.5.6.0 NAME ''top'' DESC ''top of the superclass chain'' ABSTRACT MUST objectClass )'
]
