Class {
	#name : 'LDAPSearchRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPSearchRequestTest >> testBasicSearch [
	| conn search req rr |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].
	
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new.
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' } ).
	
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.	
]

{ #category : 'tests' }
LDAPSearchRequestTest >> testFilters [
	| conn req rr search |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].
	
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new; 
		filter: (LDAPFilter with: 'objectclass').
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	search filter: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')).
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter andOf: (OrderedCollection new
						add: (LDAPFilter not: (LDAPFilter with: 'cn' equalTo: 'test1')); 
						add: (LDAPFilter not: (LDAPFilter with: 'sn' equalTo: 'test2'));
						yourself )).
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.	
]

{ #category : 'tests' }
LDAPSearchRequestTest >> testFiltersOperators [
	| conn req rr search |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].
	
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new; 
		filter: (LDAPFilter with: 'objectclass').
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test1'. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { 'cn=test1'} ).

	search filter: (LDAPFilter with: 'cn' equalTo: 'test1') not.
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil. 'cn=test2'. 'cn=test3'. 'cn=test4'. 'cn=test5' }).

	search filter: ((LDAPFilter with: 'cn' equalTo: 'test1') not &
						(LDAPFilter with: 'sn' equalTo: 'test2') not).
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr expecting: { nil . 'cn=test3' .  'cn=test4'. 'cn=test5' }).
	
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.	
]

{ #category : 'tests' }
LDAPSearchRequestTest >> testNamingContexts [
	| conn req rr search |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].
	
	search := LDAPSearchRequest new 
		base: ''; 
		scope: LDAPBaseObjectScope new; 
		attrs: { 'namingContexts' }.
	req := conn request: search.
	rr := req responses.
	self assert: req success.
	req signalExceptions.
	self assert: (self checkSearchResults: rr  expectingAttr: 'namingContexts' withValue: self baseDN).

	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.	
]

{ #category : 'tests' }
LDAPSearchRequestTest >> testSearchWithNext [
	| conn req rr r search |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].
	
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new.
	req := conn request: search.
	rr := OrderedCollection new.
	[(r := req next) isNil ] whileFalse: [rr add: r ].
	self assert: req success.
	req signalExceptions.
	
	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.	
]
