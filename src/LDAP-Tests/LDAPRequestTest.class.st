"
This test expects a LDAP server on `localhost` with a single entry in the tree:

```language=ldif
		dn: dc=example, dc=com
		dc: example
		objectClass: dcObject
		objectClass: organization
		o: test
```

"
Class {
	#name : 'LDAPRequestTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'utilities' }
LDAPRequestTest >> add: aName for: aConnection [
	|  req attrs |
	attrs := Dictionary new
		at: 'objectClass' put: 'person';
		at: 'cn' put: aName;
		at: 'sn' put: aName;
		yourself.
		
	req := aConnection request: (LDAPAddRequest new dn: (self cn: aName); attrs: attrs).
	req wait.

]

{ #category : 'accessing - defaults' }
LDAPRequestTest >> baseDN [
	^ 'dc=example,dc=com'
]

{ #category : 'accessing - defaults' }
LDAPRequestTest >> bindDN [
	^ self cn: 'admin'
]

{ #category : 'utilities' }
LDAPRequestTest >> checkSearchResults: aResult expecting: expectedRDNs [
	aResult size  < expectedRDNs size
		ifTrue: [ ^ false ].
	
	^ expectedRDNs allSatisfy: [:eachExpected | | qualified |
		qualified := eachExpected
			ifNil: [ self baseDN ]
			ifNotNil: [ String streamContents: [ :s  | s << eachExpected << ',' << self baseDN ] ].
		aResult anySatisfy: [ :eachResult | eachResult matchedDN = qualified ]
	]
]

{ #category : 'utilities' }
LDAPRequestTest >> checkSearchResults: aResult expectingAttr: attrDesc withValue: attrValue [
	^ aResult anySatisfy: [ :eachResult | 
		| attributes |
		attributes := eachResult attrsAsDictionary.
		attributes at: attrDesc 
			ifPresent: [ :set | set includes: attrValue ] 
			ifAbsent: [ false ]
	]

]

{ #category : 'utilities' }
LDAPRequestTest >> cn: aString [
	^ String streamContents: [ :s | s << 'cn=' << aString << ',' << self baseDN ]
]

{ #category : 'utilities' }
LDAPRequestTest >> connect [
	| req conn |
	conn := LDAPConnection to: self hostname port: self port.
	req := conn request: (LDAPBindRequest new username: self bindDN; password: self password).
	req wait.
	^ conn


]

{ #category : 'utilities' }
LDAPRequestTest >> delete: aName for: aConnection [
	|  req  |
	req := aConnection request: (LDAPDelRequest new dn: (self cn: aName)).
	req wait.

]

{ #category : 'accessing - defaults' }
LDAPRequestTest >> hostname [
	^ '127.0.0.1'
]

{ #category : 'accessing - defaults' }
LDAPRequestTest >> password [
	^ 'secret'
]

{ #category : 'accessing - defaults' }
LDAPRequestTest >> port [
	^ 389
]

{ #category : 'utilities' }
LDAPRequestTest >> someTestCns [
	^ (1 to: 5) collect:[ :i | String streamContents: [ :s | s << 'test' << i asString ] ]
]
