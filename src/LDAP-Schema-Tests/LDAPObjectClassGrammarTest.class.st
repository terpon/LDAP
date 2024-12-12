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
LDAPObjectClassGrammarTest >> testObjectClass [ 

	self fail: '(what)' rule: #objectClass.
	self parse: self top rule: #objectClass.
	self assert: result equals: { '2.5.6.0'. #('top') . 'top of the superclass chain'. nil. nil. #abstract . #('objectClass'). nil . OrderedCollection empty }.
	

]

{ #category : 'accessing' }
LDAPObjectClassGrammarTest >> top [

	^ '( 2.5.6.0 NAME ''top'' DESC ''top of the superclass chain'' ABSTRACT MUST objectClass )'
]
