Class {
	#name : 'LDAPBindRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPBindRequestTest >> testBind [
	| req conn |
	conn := LDAPConnection to: self hostname port: self port.
	req := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	req wait.
	self assert: req success.
	req signalExceptions.
	conn disconnect.
]

{ #category : 'tests' }
LDAPBindRequestTest >> testDoubleBind [
	| conn req bind |
	conn := self connect.
	bind := LDAPBindRequest new username: self bindDN; password: self password.
	req := conn request: bind.
	req wait.
	self assert: req success.
	req signalExceptions.
	conn disconnect.
]

{ #category : 'connecting' }
LDAPBindRequestTest >> testSSLConnection [
	| req conn |
	"This should be in LDAP-SSL-Tests package"
	LDAPSConnection ifNil: [ ^ self ].
	
	[ conn := LDAPSConnection to: self hostname port: 636 ]
		onErrorDo: [ self skip: 'no SSL connection' ].
	req := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	req wait.
	self assert: req success.
	req signalExceptions.

	conn disconnect.
]
