Class {
	#name : 'LDAPModifyRequestTest',
	#superclass : 'LDAPRequestTest',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPModifyRequestTest >> testModify [
	| conn req rr ops search mod |
	conn := self connect.
	self add: 'test1' for: conn. 
	search := LDAPSearchRequest new 
		base: self baseDN; 
		scope: LDAPWholeSubtreeScope new; 
		derefAliases: LDAPNeverDeferAliases new;
		filter: (LDAPFilter with: 'cn' equalTo: 'test1').
	req := conn request: search.
	req wait.
	rr := req responses first.
	
	ops :=  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.

	mod := LDAPModifyRequest new dn: (rr matchedDN); ops: ops.
	req := conn request: mod.
	req wait.
	
	req := conn request: (LDAPCompareRequest new dn: (self cn: 'test1'); comparing: (LDAPFilter with: 'sn' equalTo: 'test5sn')).
	req wait.
	self assert: (req result).
	self delete: 'test1' for: conn. 
	conn disconnect.	
]
