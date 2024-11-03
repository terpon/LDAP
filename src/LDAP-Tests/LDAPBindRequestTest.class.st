Class {
	#name : 'LDAPBindRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPBindRequestTest >> testBind [
	| conn |
	conn := self connect.
	conn disconnect.
]

{ #category : 'tests' }
LDAPBindRequestTest >> testDoubleBind [
	| conn req bind |
	conn := self connect.
	bind := LDAPBindRequest new username: self bindDN; password: self password.
	req := conn request: bind.
	req wait.
	conn disconnect.
]

{ #category : 'connecting' }
LDAPBindRequestTest >> testSSLConnection [
	| req conn |
	"This should be in LDAP-SSL-Tests package"
	LDAPSConnection ifNil: [ ^ self ].
	
	conn := LDAPSConnection to: self hostname port: 636.
	req := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	req wait.
	self assert: (req result).


]