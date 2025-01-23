Class {
	#name : 'LDAPConnectionTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Connection',
	#package : 'LDAP-Tests',
	#tag : 'Connection'
}

{ #category : 'tests' }
LDAPConnectionTest >> testConnect [

	| connection |
	connection := LDAPConnection new host: LDAPTestServer hostname; port: LDAPTestServer port.
	self deny: connection isConnected.
	connection connect.
	self assert: connection isConnected.
	connection disconnect.
	self deny: connection isConnected.


]
