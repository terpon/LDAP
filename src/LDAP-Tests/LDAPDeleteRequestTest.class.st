Class {
	#name : 'LDAPDeleteRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Requests',
	#package : 'LDAP-Tests',
	#tag : 'Requests'
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
