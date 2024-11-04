Class {
	#name : 'LDAPAddRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPAddRequestTest >> testAddAttribute [
	| req |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.
	req addAttribute: LDAPPartialAttribute new.
	self deny: req attrs isEmpty.
	self assert: req attrs size equals: 1.

	req addAttribute: LDAPPartialAttribute new.
	self assert: req attrs size equals: 2.

]

{ #category : 'tests' }
LDAPAddRequestTest >> testAtPut [
	| req |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.
	
	req at: 'objectclass' put: 'top'.
	self assert: req attrs size equals: 1.

	req at: 'objectclass' put: 	#( 'top' 'domain' ).
	self assert: req attrs size equals: 1.

	req at: 'cn' put: 'foo'.
	self assert: req attrs size equals: 2.

	req at: 'cn' put: 'bar'.
	self assert: req attrs size equals: 2.

]

{ #category : 'tests' }
LDAPAddRequestTest >> testAttrs [
	| req attrs |
	req := LDAPAddRequest new.
	self assert: req attrs isEmpty.

	attrs := Dictionary new
			at: 'objectClass' put: #( 'top' 'person');
			at: 'cn' put: 'name';
			at: 'sn' put: 'name';
			yourself.

	req attrs: attrs.
	self assert: req attrs size equals: 3.
			

]

{ #category : 'tests' }
LDAPAddRequestTest >> testCollectionValues [
	| conn req attrs |
	conn := self connect.
	self someTestCns do: [ :name| | add |
		attrs := Dictionary new
			at: 'objectClass' put: (OrderedCollection new add: 'person'; yourself);
			at: 'cn' put: (OrderedCollection new add: name; yourself);
			at: 'sn' put: (OrderedCollection new add: name; yourself);
			yourself.
		
		add := LDAPAddRequest new dn: (self cn: name); attrs: attrs.
		req := conn request: add.
		req wait.
		self assert: req success.
		req signalExceptions.
	].
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect
]

{ #category : 'tests' }
LDAPAddRequestTest >> testRemoveAll [
	| req |
	req := LDAPAddRequest new.
	req addAttribute: LDAPPartialAttribute new.
	self deny: req attrs isEmpty.
	
	req removeAll.
	self assert: req attrs isEmpty.
]

{ #category : 'tests' }
LDAPAddRequestTest >> testStringValues [
	| conn req attrs |
	conn := self connect.
	self someTestCns do: [ :name|
		attrs := Dictionary new
			at: 'objectClass' put: 'person';
			at: 'cn' put: name;
			at: 'sn' put: name;
			yourself.
		
		req := conn request: (LDAPAddRequest new dn: (self cn: name); attrs: attrs).
		req wait.
		self assert: req success.
		req signalExceptions.
	].
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect
]
