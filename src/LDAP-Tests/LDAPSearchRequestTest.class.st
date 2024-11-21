Class {
	#name : 'LDAPSearchRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

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
