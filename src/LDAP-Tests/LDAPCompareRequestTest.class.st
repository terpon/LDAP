Class {
	#name : 'LDAPCompareRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPCompareRequestTest >> testCompareFailure [

	| responses compare |
	self connect.
	self addSomeTestEntries.

	compare := LDAPCompareRequest new
		           name: (self cn: 'test1');
		           comparing: (LDAPFilter with: 'cn' equalTo: 'test2').
	responses := self requestAndAssertSuccess: compare.
	self deny: responses first isMatch. "this checks the compare result"


]

{ #category : 'tests' }
LDAPCompareRequestTest >> testCompareSuccess [

	| responses compare |
	self connect.
	self addSomeTestEntries.

	compare := LDAPCompareRequest new
		           name: (self cn: 'test1');
		           comparing: (LDAPFilter with: 'cn' equalTo: 'test1').
	responses := self requestAndAssertSuccess: compare.
	self assert: responses first isMatch. "this checks the compare result"

]
