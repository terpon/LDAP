Class {
	#name : 'LDAPSchemaPrimitiveGrammarTest',
	#superclass : 'PP2CompositeNodeTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'accessing' }
LDAPSchemaPrimitiveGrammarTest >> parserClass [
	^ LDAPSchemaPrimitiveGrammar 
]

{ #category : 'tests' }
LDAPSchemaPrimitiveGrammarTest >> testNumber [ 

	self parse: '0' rule: #number.
	self assert: result equals: 0.

	self parse: '7' rule: #number.
	self assert: result equals: 7.

	self fail: '0123' rule: #number.

	self parse: '1480000' rule: #number.
	self assert: result equals: 1480000.

]
