Class {
	#name : 'LDAPDelRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPDelRequestTest >> testDelete [

	self connect.
	self addSomeTestEntries.

	self someTestCns do: [ :name |
		| del |
		del := LDAPDelRequest new name: (self cn: name).
		self requestAndAssertSuccess: del.
	]
]
