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

{ #category : 'utilities' }
LDAPRequestTest >> addEntry: aName [
	|  attrs |
	attrs := Dictionary new
		at: 'objectClass' put: 'person';
		at: 'cn' put: aName;
		at: 'sn' put: aName;
		yourself.
		
	self requestAndAssertSuccess: (LDAPAddRequest new name: (self cn: aName); attributes: attrs).

]

{ #category : 'setup' }
LDAPRequestTest >> addSomeTestEntries [

	connection ifNil: [ ^ self ].
	
	self someTestCns do: [ :name |
		[ self addEntry: name ]
			on: LDAPUpdateProblemException
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
LDAPRequestTest >> connect [

	connection := LDAPConnection to: self hostname port: self port.
	self requestAndAssertSuccess: (LDAPBindRequest new username: self bindDN; password: self password).
	^ connection


]

{ #category : 'utilities' }
LDAPRequestTest >> deleteEntry: aName [

	self requestAndAssertSuccess: (LDAPDeleteRequest new name: (self cn: aName)).

]

{ #category : 'cleanup' }
LDAPRequestTest >> deleteSomeTestEntries [

	connection ifNil: [ ^ self ].
	
	self someTestCns do: [ :name |
		[ 	self request: (LDAPDeleteRequest new name: (self cn: name)) ]
			on: LDAPNameProblemException 
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
