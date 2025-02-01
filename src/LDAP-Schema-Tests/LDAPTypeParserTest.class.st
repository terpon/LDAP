Class {
	#name : 'LDAPTypeParserTest',
	#superclass : 'LDAPTypeGrammarTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'script' }
LDAPTypeParserTest >> inspectData [
<script: 'self new setUp; inspectData; tearDown' >

	(self data collect: [ :string |
		self parse: string
	 ]) inspect.
]

{ #category : 'accessing' }
LDAPTypeParserTest >> parserClass [
	^ LDAPTypeParser 
]

{ #category : 'tests' }
LDAPTypeParserTest >> testData [

	self data do: [ :string |
		self parse: string.
		self assert: result class equals: LDAPAttributeType.
		self assert: result oid isNotEmpty 
	]
]
