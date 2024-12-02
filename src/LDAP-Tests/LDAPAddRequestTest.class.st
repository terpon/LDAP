Class {
	#name : 'LDAPAddRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
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

	self connect.
	self someTestCns do: [ :name |
		| add attrs |
		attrs := Dictionary new
			         at: 'objectClass' put: { 'person' };
			         at: 'cn' put: { name };
			         at: 'sn' put: { name };
			         yourself.

		add := LDAPAddRequest new name: (self cn: name); attributes: attrs.
		self requestAndAssertSuccess: add
	].
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

	| attrs |
	self connect.
	self someTestCns do: [ :name |
		attrs := Dictionary new
			         at: 'objectClass' put: 'person';
			         at: 'cn' put: name;
			         at: 'sn' put: name;
			         yourself.

		self requestAndAssertSuccess: (LDAPAddRequest new
				        name: (self cn: name);
				        attributes: attrs)
	].
]

{ #category : 'tests' }
LDAPAddRequestTest >> testUnicode [

	| attrs dn |
	self connect.
	dn := 'cn=Éric,ou=people,dc=example,dc=com'.
	attrs := Dictionary new
		        at: 'objectClass' put: 'person';
		        at: 'cn' put: 'Éric';
		        at: 'sn' put: 'Λαдоғទ្ឋឃោテクđešić';
		        yourself.

	self requestAndAssertSuccess: (LDAPAddRequest new name: dn; attributes: attrs).
	self requestAndAssertSuccess: (LDAPDeleteRequest new name: dn).

]
