Class {
	#name : 'LDAPCompareRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPCompareRequestTest >> testCompareFailure [
	| conn req compare |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].

	compare := LDAPCompareRequest new 
		dn: (self cn: 'test1'); 
		comparing: (LDAPFilter with: 'cn' equalTo: 'test2').
	req := conn request: compare.
	req wait.
	self assert: req success. "this checks the success of the request, not the compare"
	req signalExceptions.
	self deny: req responses first isMatch. "this checks the compare result"

	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.
]

{ #category : 'tests' }
LDAPCompareRequestTest >> testCompareSuccess [
	| conn req compare |
	conn := self connect.
	self someTestCns do: [ :name| self add: name for: conn ].

	compare := LDAPCompareRequest new 
		dn: (self cn: 'test1'); 
		comparing: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: compare.
	req wait.
	self assert: req success. "this checks the success of the request, not the compare"
	req signalExceptions.
	self assert: req responses first isMatch. "this checks the compare result"

	self someTestCns do: [ :name| self delete: name for: conn ].
	conn disconnect.
]
