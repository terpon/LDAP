Class {
	#name : 'LDAPObjectClassParserTest',
	#superclass : 'LDAPObjectClassGrammarTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'script' }
LDAPObjectClassParserTest >> inspectData [
<script: 'self new setUp; inspectData; tearDown' >

	(self data collect: [ :string |
		self parse: string
	 ]) inspect.


]

{ #category : 'script' }
LDAPObjectClassParserTest >> inspectShortData [
<script: 'self new setUp; inspectShortData; tearDown' >

	(self shortData collect: [ :string |
		self parse: string
	 ]) inspect.


]

{ #category : 'accessing' }
LDAPObjectClassParserTest >> parserClass [
	^ LDAPObjectClassParser 
]

{ #category : 'tests' }
LDAPObjectClassParserTest >> testData [

	self data do: [ :string |
		self parse: string.
		self assert: result class equals: LDAPObjectClass.
		self assert: result oid isNotEmpty.
		self assert: result names isNotEmpty.
		result kind = #structural ifTrue: [ self assert: result superiors isNotEmpty ].
	 ]
]

{ #category : 'tests' }
LDAPObjectClassParserTest >> testObjectClass [ 

	self fail: '(nope)' rule: #objectClass.
	self parse: self top rule: #objectClass.
	self assert: result class equals: LDAPObjectClass.
	self assert: result oid equals: '2.5.6.0'.
	self assert: result names equals: #('top').
	self assert: result description equals: 'top of the superclass chain'.
	self assert: result obsolete not.
	self assert: result superiors isEmpty.
	self assert: result kind equals: #abstract.
	self assert: result must equals: #('objectClass').
	self assert: result may isEmpty.
]

{ #category : 'tests' }
LDAPObjectClassParserTest >> testObsolete [

	self parse: '(1.2.3 NAME ''foo'' DESC ''bar'' OBSOLETE SUP top)' rule: #objectClass.
	self assert: result class equals: LDAPObjectClass.
	self assert: result oid equals: '1.2.3'.
	self assert: result names equals: #('foo').
	self assert: result description equals: 'bar'.
	self assert: result obsolete.
	self assert: result superiors equals: #('top').
	self assert: result kind equals: #structural.
]
