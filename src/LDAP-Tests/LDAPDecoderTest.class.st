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
	#name : 'LDAPDecoderTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Decoder',
	#package : 'LDAP-Tests',
	#tag : 'Decoder'
}

{ #category : 'tests' }
LDAPDecoderTest >> testReadFrom [
	| message id cn dn code result seq encoded |
	seq := BERSequence new.
	id := BERInteger new content: 2.
	seq addElement: id.
	result := LDAPBindResult new.
	code := BEREnumerated new content: 0.
	result addElement: code.
	cn := 'cn=root,cn=wheel,dc=example,dc=com'.
	dn := BEROctetString new from: cn.
	result addElement: dn.
	seq addElement: result.
	encoded := ByteString streamContents: [ :s | seq writeOn: s ].
	
	message := LDAPDecoder new readFrom: encoded readStream.
	self assert: message class equals: LDAPMessage.
	self assert: message id equals: 2.
	self assert: message response resultCode equals: 0.
	self assert: message response name equals: cn.
]
