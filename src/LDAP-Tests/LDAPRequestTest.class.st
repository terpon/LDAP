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
	#instVars : [
		'connection'
	],
	#category : 'LDAP-Tests-Utility',
	#package : 'LDAP-Tests',
	#tag : 'Utility'
}

{ #category : 'testing' }
LDAPRequestTest class >> isAbstract [

	^ self = LDAPRequestTest
]

{ #category : 'utilities' }
LDAPRequestTest >> addEntry: aName [
	|  attrs cn dn |
	cn := aName isString ifTrue: [ aName ] ifFalse: [ aName first ].
	dn := aName isString ifTrue: [ self cn: aName ] ifFalse: [ self cns: aName ].
	attrs := Dictionary new
		at: 'objectClass' put: 'person';
		at: 'cn' put: cn;
		at: 'sn' put: cn;
		yourself.
		
	self requestAndAssertSuccess: (LDAPAddRequest new name: dn; attributes: attrs).

]

{ #category : 'setup' }
LDAPRequestTest >> addSomeTestEntries [

	connection ifNil: [ ^ self ].
	
	self someTestCns do: [ :name |
		[ self addEntry: name ]
			on: LDAPUpdateException
			do: [ :ex | ex resume ]
	]

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
		aResult anySatisfy: [ :eachResult | eachResult name = qualified ]
	]
]

{ #category : 'utilities' }
LDAPRequestTest >> cn: aString [
	^ String streamContents: [ :s | s << 'cn=' << aString << ',' << self baseDN ]
]

{ #category : 'utilities' }
LDAPRequestTest >> cns: aCollection [
	^ String streamContents: [ :s | 
			aCollection do: [ :each | s << 'cn=' << each ] separatedBy: [ s nextPut: $, ]. 
			s << ',' << self baseDN 
		]
]

{ #category : 'utilities' }
LDAPRequestTest >> connect [

	connection := LDAPConnection to: self hostname port: self port.
	self requestAndAssertSuccess: (LDAPBindRequest new username: self bindDN; password: self password).
	^ connection


]

{ #category : 'utilities' }
LDAPRequestTest >> deleteEntry: aName [
	
	| dn |
	dn := aName isString ifTrue: [ self cn: aName ] ifFalse: [ self cns: aName ].
	self requestAndAssertSuccess: (LDAPDeleteRequest new name: dn).

]

{ #category : 'cleanup' }
LDAPRequestTest >> deleteSomeTestEntries [

	connection ifNil: [ ^ self ].
	
	self someTestCns do: [ :name |
		[ 	self request: (LDAPDeleteRequest new name: (self cn: name)) ]
			on: LDAPNameException 
			do: [ :ex | ex resume ] ].


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

{ #category : 'running' }
LDAPRequestTest >> request: aLDAPRequest [
	| command |	
	command := connection request: aLDAPRequest.
	command ifNil: [ ^ nil ].
	^ command responses
]

{ #category : 'running' }
LDAPRequestTest >> requestAndAssertSuccess: aLDAPRequest [
	| command responses |	
	command := connection request: aLDAPRequest.
	responses := command responses.
	command signalExceptions.
	self assert: command success.
	^ responses

]

{ #category : 'utilities' }
LDAPRequestTest >> someTestCns [
	^ (1 to: 5) collect:[ :i | String streamContents: [ :s | s << 'test' << i asString ] ]
]

{ #category : 'running' }
LDAPRequestTest >> tearDown [ 

	self deleteSomeTestEntries.
	connection ifNotNil: [ 
		connection disconnect.
		connection := nil
	].
	
	super tearDown
]
