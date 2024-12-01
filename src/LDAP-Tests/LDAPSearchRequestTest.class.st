Class {
	#name : 'LDAPSearchRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPSearchRequestTest >> inspectBasicSearch [
<script: 'self new setUp; inspectBasicSearch; tearDown' >

	| search responses  add attrs name dn |
	self connect.
"	name := 'deep'.
	dn := 'cn=deep,ou=foofoo,o=foo,o=oo,cn=foo1,dc=example,dc=com'.
		attrs := Dictionary new
			         at: 'objectClass' put: { 'person' };
			         at: 'cn' put: { name };
			         at: 'sn' put: { name };
			         yourself.

		add := LDAPAddRequest new name: dn; attributes: attrs.
		self requestAndAssertSuccess: add."
		
	search := LDAPSearchRequest new
		          "base: 'cn=bar55,dc=example,dc=com'self baseDN;"
		          base: self baseDN;
		          "scope: LDAPWholeSubtreeScope new."
		          scope: LDAPSingleLevelScope new.
	responses := self requestAndAssertSuccess: search.
	responses inspect.


]

{ #category : 'tests' }
LDAPSearchRequestTest >> inspectBasicSearch2 [
<script: 'self new setUp; inspectBasicSearch2; tearDown' >

	| search responses |
	self connect.
	search := LDAPSearchRequest new
		          base: 'cn=bar55,dc=example,dc=com';
		          scope: LDAPBaseObjectScope new.
	responses := self requestAndAssertSuccess: search.
	responses inspect.


]

{ #category : 'tests' }
LDAPSearchRequestTest >> testBasicSearch [

	| search responses |
	self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new.
	responses := self requestAndAssertSuccess: search.
	"responses inspect."

	self assert: (self
			 checkSearchResults: responses
			 expecting:
			 { nil. 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

]

{ #category : 'tests' }
LDAPSearchRequestTest >> testFailure [

	| responses search |
	self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new;
		          filter: (LDAPFilter with: 'cn' equalTo: 'should_not_be_there_567329').
	responses := self requestAndAssertSuccess: search.
	self assert: responses size equals: 1.

	search := LDAPSearchRequest new
		          base: (self cn: 'should_not_be_there_937461');
		          scope: LDAPWholeSubtreeScope new.
	responses := self request: search.
	self assert: responses size equals: 1.
	self deny: responses first success.
	self assert: responses first resultCode equals: 32.
	 

]

{ #category : 'tests' }
LDAPSearchRequestTest >> testFilters [

	| responses search |
	self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new;
		          filter: (LDAPFilter with: 'objectclass').
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting:
			 { nil. 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	responses := self requestAndAssertSuccess: search.
	self assert: (self checkSearchResults: responses expecting: { 'cn=test1' }).

	search filter:
		(LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')).
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter andOf: (OrderedCollection new
				  add: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1'));
				  add: (LDAPFilter not: (LDAPFilter with: 'sn' equalTo: 'test2'));
				  yourself)).
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting: { nil. 'cn=test3'. 'cn=test4'. 'cn=test5' }).
]

{ #category : 'tests' }
LDAPSearchRequestTest >> testFiltersOperators [

	| responses search |
	self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new;
		          filter: (LDAPFilter with: 'objectclass').
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting:
			 { nil. 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	responses := self requestAndAssertSuccess: search.
	self assert: (self checkSearchResults: responses expecting: { 'cn=test1' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1') not.
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1') not
		& (LDAPFilter with: 'sn' equalTo: 'test2') not.
	responses := self requestAndAssertSuccess: search.
	self assert: (self
			 checkSearchResults: responses
			 expecting: { nil. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

]

{ #category : 'tests' }
LDAPSearchRequestTest >> testNamingContexts [

	| responses search attrs |
	self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
	responses := self requestAndAssertSuccess: search.

	self assert: responses size equals: 2.
	self assert: responses second resultCode equals: 0.
	attrs := responses first asDictionary.
	self assert: (attrs includesKey: 'namingContexts').
	self assert: ((attrs at: 'namingContexts') includes: self baseDN).

]

{ #category : 'tests' }
LDAPSearchRequestTest >> testSearchWithNext [

	| conn command list r search |
	conn := self connect.
	self addSomeTestEntries.

	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new.
	command := conn request: search.
	list := OrderedCollection new.
	[ (r := command next) isNil ] whileFalse: [ list add: r ].
	self assert: command success.
	command signalExceptions.

]
