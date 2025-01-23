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

{ #category : 'tests' }
LDAPConnectionTest >> testIsConnected [

	| flag connection |
	flag := false.
	connection := LDAPConnection new host: LDAPTestServer hostname; port: LDAPTestServer port.
	connection announcer when: LDAPIsConnected do: [ flag := true ] for: self. 
	connection connect.
	self assert: flag.
	connection disconnect.

]

{ #category : 'tests' }
LDAPConnectionTest >> testIsDisconnected [

	| flag connection |
	flag := false.
	connection := LDAPConnection new host: LDAPTestServer hostname; port: LDAPTestServer port.
	connection announcer when: LDAPIsDisconnected do: [ flag := true ] for: self. 
	connection connect.
	self deny: flag.
	connection disconnect.
	self assert: flag.

]
