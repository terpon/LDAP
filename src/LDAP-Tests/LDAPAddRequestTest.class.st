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
	self assert: req attributes isEmpty.
	req addAttribute: LDAPPartialAttribute new.
	self deny: req attributes isEmpty.
	self assert: req attributes size equals: 1.

	req addAttribute: LDAPPartialAttribute new.
	self assert: req attributes size equals: 2.

]

{ #category : 'tests' }
LDAPAddRequestTest >> testAtPut [
	| req |
	req := LDAPAddRequest new.
	self assert: req attributes isEmpty.
	
	req at: 'objectclass' put: 'top'.
	self assert: req attributes size equals: 1.

	req at: 'objectclass' put: 	#( 'top' 'domain' ).
	self assert: req attributes size equals: 1.

	req at: 'cn' put: 'foo'.
	self assert: req attributes size equals: 2.

	req at: 'cn' put: 'bar'.
	self assert: req attributes size equals: 2.

]

{ #category : 'tests' }
LDAPAddRequestTest >> testAttributes [
	| req attrs |
	req := LDAPAddRequest new.
	self assert: req attributes isEmpty.

	attrs := Dictionary new
			at: 'objectClass' put: #( 'top' 'person');
			at: 'cn' put: 'name';
			at: 'sn' put: 'name';
			yourself.

	req attributes: attrs.
	self assert: req attributes size equals: 3.
			

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
		
		add := LDAPAddRequest new name: (self cn: name); attributes: attrs.
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
	self deny: req attributes isEmpty.
	
	req removeAll.
	self assert: req attributes isEmpty.
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
		
		req := conn request: (LDAPAddRequest new name: (self cn: name); attributes: attrs).
		req wait.
		self assert: req success.
		req signalExceptions.
	].
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect
]
