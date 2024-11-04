Class {
	#name : 'LDAPDelRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPDelRequestTest >> testDelete [
	| conn req |
	conn := self connect.
	self someTestCns do: [ :name| 
		[ self add: name for: conn ]
		on: LDAPUpdateProblemException  do: [ :ex | ex traceCr. "allow existing entry before deletion" ] ].
	self someTestCns do: [ :name| | del |
		del := LDAPDelRequest new dn: (self cn: name).
		req := conn request: del.
		req wait.
		self assert: req success.
		req signalExceptions.
	].
	conn disconnect
]
