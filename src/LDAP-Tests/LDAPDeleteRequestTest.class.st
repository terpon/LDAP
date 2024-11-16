Class {
	#name : 'LDAPDeleteRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPDeleteRequestTest >> testDelete [

	self connect.
	self addSomeTestEntries.

	self someTestCns do: [ :name |
		| del |
		del := LDAPDeleteRequest new name: (self cn: name).
		self requestAndAssertSuccess: del.
	]
]
