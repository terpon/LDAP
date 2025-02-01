Class {
	#name : 'LDAPSConnectionTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Connection',
	#package : 'LDAP-Tests',
	#tag : 'Connection'
}

{ #category : 'connecting' }
LDAPSConnectionTest >> testConnect [
	| conn command |
	"This should be in LDAP-SSL-Tests package"
	
	conn := [ LDAPSConnection to: LDAPTestServer hostname port: LDAPTestServer sslPort ]
		onErrorDo: [ self skip: 'no SSL connection' ].
	self assert: conn isConnected.
	command := conn request: (LDAPBindRequest new username: LDAPTestServer username; password: LDAPTestServer password).
	command wait.
	self assert: command success.
	command signalExceptions.

	conn disconnect.
	self deny: conn isConnected.
]
