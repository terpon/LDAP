Class {
	#name : 'LDAPDelRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPDelRequestTest >> testDelete [

	self connect.
	self addSomeTestEntries.

	self someTestCns do: [ :name |
		| del |
		del := LDAPDeleteRequest new name: (self cn: name).
		self requestAndAssertSuccess: del.
	]
]
