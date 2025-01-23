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

{ #category : 'connecting' }
LDAPBindRequestTest >> testSSLConnection [
	| conn command |
	"This should be in LDAP-SSL-Tests package"
	
	conn := [ LDAPSConnection to: self hostname port: 636 ]
		onErrorDo: [ self skip: 'no SSL connection' ].
	command := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	command wait.
	self assert: command success.
	command signalExceptions.

	conn disconnect.
]
