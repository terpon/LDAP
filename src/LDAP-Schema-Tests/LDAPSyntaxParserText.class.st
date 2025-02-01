Class {
	#name : 'LDAPSyntaxParserText',
	#superclass : 'LDAPSyntaxGrammarTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'script' }
LDAPSyntaxParserText >> inspectData [
<script: 'self new setUp; inspectData; tearDown' >

	(self data collect: [ :string |
		self parse: string
	 ]) inspect.


]

{ #category : 'accessing' }
LDAPSyntaxParserText >> parserClass [
	^ LDAPSyntaxParser
]

{ #category : 'tests' }
LDAPSyntaxParserText >> testData [

	self data do: [ :string |
		self parse: string rule: #syntax.
		self assert: result class equals: LDAPSyntax.
		self assert: result oid isNotEmpty.
		self assert: result description isNotEmpty.
	]
]

{ #category : 'tests' }
LDAPSyntaxParserText >> testSyntax [

	self fail: '(grr)' rule: #syntax.
	self parse: '( 1.3.6.1.4.1.1466.115.121.1.12 DESC ''Distinguished Name'' )' rule: #syntax.
	self assert: result oid equals: '1.3.6.1.4.1.1466.115.121.1.12'.
	self assert: result description equals: 'Distinguished Name'.
	self assert: result isHumanReadable.
	self assert: result doesNotRequireBinaryTransfer.
]
