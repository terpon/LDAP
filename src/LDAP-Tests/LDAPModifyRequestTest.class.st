Class {
	#name : 'LDAPModifyRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPModifyRequestTest >> testModify [

	| responses search mod |
	self connect.
	self addEntry: 'test1'.
	search := LDAPSearchRequest new
		          base: self baseDN;
		          scope: LDAPWholeSubtreeScope new;
		          derefAliases: LDAPNeverDeferAliases new;
		          filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	responses := self requestAndAssertSuccess: search.

	mod := LDAPModifyRequest new name: responses first name.
	mod addOperation: (LDAPSetAttributeChange new
			 description: 'sn';
			 values: { 'test5sn'. 'foo'. 'bar' };
			 yourself).
	mod addOperation: (LDAPAddAttributeChange new
			 description: 'description';
			 values: { 'rchueo' };
			 yourself).

	responses := self requestAndAssertSuccess: mod.

	responses := self requestAndAssertSuccess: (LDAPCompareRequest new
			        name: (self cn: 'test1');
			        comparing: (LDAPFilter with: 'sn' equalTo: 'test5sn')).

	self deleteEntry: 'test1'.
]

{ #category : 'tests' }
LDAPModifyRequestTest >> testModify2 [

	| mod |
	self connect.
	self addEntry: 'test_modify'.

	mod := LDAPModifyRequest new name: (self cn: 'test_modify').
	mod set: 'sn' to: { 'test5sn'. 'foo'. 'bar' }.
	mod description: 'description' add: 'rchueo'.

	self requestAndAssertSuccess: mod.

	self requestAndAssertSuccess: (LDAPCompareRequest new
			        name: (self cn: 'test_modify');
			        comparing: (LDAPFilter with: 'sn' equalTo: 'foo')).

	self deleteEntry: 'test_modify'.

]
