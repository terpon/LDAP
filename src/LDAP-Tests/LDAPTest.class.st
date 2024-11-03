"
This test expects at least this entry in the directory:
```language=ldif
		dn: dc=example, dc=com
		dc: example
		objectClass: domain
```

The user `cn=admin,dc=example,dc=com` should have write access to the directory using password `secret`

"
Class {
	#name : 'LDAPTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'tests' }
LDAPTest >> testMessage [
	| message id cn dn code result seq encoded |
	seq := BERSequence new.
	id := BERInteger new value: 2.
	seq addElement: id.
	result := LDAPBindResult new.
	code := BEREnumerated new value: 0.
	result addElement: code.
	cn := 'cn=root,cn=wheel,dc=example,dc=com'.
	dn := BEROctetString new value: cn.
	result addElement: dn.
	seq addElement: result.
	encoded := ByteString streamContents: [ :s | seq writeOn: s ].
	
	message := LDAPMessage newFrom: encoded readStream.
	self assert: message id equals: 2.
	self assert: message response resultCode equals: 0.
	self assert: message response matchedDN equals: cn.
]
