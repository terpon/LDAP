Class {
	#name : 'LDAPModifyNameRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests-Requests',
	#package : 'LDAP-Tests',
	#tag : 'Requests'
}

{ #category : 'tests' }
LDAPModifyNameRequestTest >> testDropRelativeName [ 

	| responses modify before after compare |
	before := 'test_modify_name_before'.
	after := 'test_modify_name_after'.
	self connect.
	self addEntry: before.
	modify := LDAPModifyNameRequest new name: (self cn: before);
		newRelativeName: 'cn=',after;
		dropRelativeName.
	responses := self requestAndAssertSuccess: modify.

	compare := LDAPCompareRequest new
		           name: (self cn: after);
		           comparing: (LDAPFilter with: 'cn' equalTo: before).
	responses := self requestAndAssertSuccess: compare.
	self deny: responses first isMatch. "this checks the compare result"

	self deleteEntry: after.

]

{ #category : 'tests' }
LDAPModifyNameRequestTest >> testKeepRelativeName [ 

	| responses modify before after compare |
	before := 'test_modify_name_before'.
	after := 'test_modify_name_after'.
	self connect.
	self addEntry: before.
	modify := LDAPModifyNameRequest new name: (self cn: before);
		newRelativeName: 'cn=',after;
		keepRelativeName.
	responses := self requestAndAssertSuccess: modify.

	compare := LDAPCompareRequest new
		           name: (self cn: after);
		           comparing: (LDAPFilter with: 'cn' equalTo: before).
	responses := self requestAndAssertSuccess: compare.
	self assert: responses first isMatch. "this checks the compare result"

	self deleteEntry: after.

]

{ #category : 'tests' }
LDAPModifyNameRequestTest >> testNewRelativeName [ 

	| search responses modify |
	self connect.
	self addEntry: 'test_modify_name'.
	modify := LDAPModifyNameRequest new name: (self cn:'test_modify_name');
		newRelativeName: 'cn=test_new_name'.
	responses := self requestAndAssertSuccess: modify.

	search := LDAPSearchRequest new base: (self cn: 'test_modify_name').
	responses := self request: search.
	self deny: responses first success.
	self assert: responses first resultCode equals: 32.

	search := LDAPSearchRequest new base: (self cn: 'test_new_name').
	responses := self requestAndAssertSuccess: search.

	self deleteEntry: 'test_new_name'.

]

{ #category : 'tests' }
LDAPModifyNameRequestTest >> testUnderName [ 

	| search responses modify a1 a2 b1 b2 |
	a1 := 'test_mn1'.
	a2 := 'test_mn2'.
	b1 := 'mod_before'.
	b2 := 'mod_after'.
	self connect.
	self addEntry: a1.
	self addEntry: a2.
	self addEntry: { b1 . a1 }.
	
	modify := LDAPModifyNameRequest new name: (self cns:{ b1 . a1 });
		newRelativeName: 'cn=',b2;
		underName: (self cn: a2).
	responses := self requestAndAssertSuccess: modify.

	search := LDAPSearchRequest new base: (self cns: { b2 . a2 }).
	responses := self requestAndAssertSuccess: search.

	self deleteEntry: { b2 . a2 }.
	self deleteEntry: a1.
	self deleteEntry: a2.
]

{ #category : 'tests' }
LDAPModifyNameRequestTest >> testUnderNameSameRDN [

	| search responses modify a1 a2 b |
	a1 := 'test_mn1'.
	a2 := 'test_mn2'.
	b := 'mod_name'.
	self connect.
	self addEntry: a1.
	self addEntry: a2.
	self addEntry: { b . a1 }.
	
	modify := LDAPModifyNameRequest new name: (self cns:{ b . a1 });
		newRelativeName: 'cn=',b;
		underName: (self cn: a2).
	responses := self requestAndAssertSuccess: modify.

	search := LDAPSearchRequest new base: (self cns: { b . a2 }).
	responses := self requestAndAssertSuccess: search.

	self deleteEntry: { b . a2 }.
	self deleteEntry: a1.
	self deleteEntry: a2.
]
