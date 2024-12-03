Class {
	#name : 'LDAPNameTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPNameTest >> testStripBase [

	| name |
	name := LDAPString new content: 'o=a'.
	self assert: (name stripBase: 'o=c,o=b,o=a') equals: 'o=c,o=b'.
	self assert: (name stripBase: 'o=b,o=a') equals: 'o=b'.
	self assert: (name stripBase: 'o=a') equals: ''.
	self assert: (name stripBase: 'o=b') equals: 'o=b'.
	self assert: (name stripBase: 'o=b+o=a') equals: 'o=b+o=a'.

]
