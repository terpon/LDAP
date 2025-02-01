Class {
	#name : 'LDAPBindRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Requests',
	#package : 'LDAP-Tests',
	#tag : 'Requests'
}

{ #category : 'tests' }
LDAPBindRequestTest >> testBind [
	| command conn |
	conn := LDAPConnection to: self hostname port: self port.
	command := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	command wait.
	self assert: command success.
	command signalExceptions.
	conn disconnect.
]

{ #category : 'tests' }
LDAPBindRequestTest >> testDoubleBind [
	| bind |
	self connect.
	bind := LDAPBindRequest new username: self bindDN; password: self password.
	self requestAndAssertSuccess: bind.

]
