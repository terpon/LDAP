Class {
	#name : 'LDAPModifyRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPModifyRequestTest >> testModify [
	| conn req rr search mod |
	conn := self connect.
	self add: 'test1' for: conn. 
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new; 
		derefAliases: LDAPNeverDeferAliases new;
		filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	req wait.
	self assert: req success.
	req signalExceptions.
	rr := req responses first.
	
	mod := LDAPModifyRequest new name: (rr name).
	mod addOperation: (LDAPSetAttributeChange new description: 'sn'; values: { 'test5sn' . 'foo' . 'bar'}; yourself).
	mod addOperation: (LDAPAddAttributeChange new description: 'description'; values: {'rchueo'}; yourself).

	req := conn request: mod.
	req wait.
	self assert: req success.
	req signalExceptions.
	
	req := conn request: (LDAPCompareRequest new name: (self cn: 'test1'); comparing: (LDAPFilter with: 'sn' equalTo: 'test5sn')).
	req wait.
	self assert: req success.
	req signalExceptions.
	self delete: 'test1' for: conn. 
	conn disconnect.	
]
