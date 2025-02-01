Class {
	#name : 'BERDecoderTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Decoder',
	#package : 'LDAP-Tests',
	#tag : 'Decoder'
}

{ #category : 'tools' }
BERDecoderTest >> debugHex: aString [
	
	^ ByteString streamContents: [ :s |
			aString groupsOf: 2 atATimeDo: [ :hi :lo | | byte |
				byte := (hi digitValue bitShift: 4) + lo digitValue.
				s nextPut: (byte asCharacter) ].
		].

]

{ #category : 'tools' }
BERDecoderTest >> formatWithHex: aString [

	^ String streamContents: [ :stream |
			aString groupsOf: 2 atATimeDo: [ :hi :lo |
				stream nextPutAll: '16r'.
				(hi ~= $0) ifTrue: [ stream nextPut: hi ].
				stream nextPut: lo.
			]  
		]
]

{ #category : 'tests' }
BERDecoderTest >> testAddRequest [
	| request encoded hex expected attrs |
	"using a Dictionary could generate different encodings depending on the order of iteration."
	"we'll rely on the implementation calling associationsDo: to work with this Array."
	attrs := { 
		'objectClass' -> (OrderedCollection new addLast: 'person'; yourself).
		'cn' -> (OrderedCollection new addLast: 'test2'; yourself).
		'sn' -> (OrderedCollection new addLast: 'test2'; yourself).
	}.

	request := LDAPAddRequest new name: 'cn=test2,dc=linalco,dc=test'; attributes: attrs.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	hex := encoded asString asHex.
	expected := self formatWithHex: '305B0201016856041B636E3D74657374322C64633D6C696E616C636F2C64633D7465737430373017040B6F626A656374436C61737331080406706572736F6E300D0402636E310704057465737432300D0402736E310704057465737432'.
	self assert: hex equals: expected
]

{ #category : 'tests' }
BERDecoderTest >> testBindRequest [
	| request encoded expected |
	request := LDAPBindRequest new username: 'cn=admin,dc=linalco,dc=test'; password: 'secret'.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '302D0201016028020103041B636E3D61646D696E2C64633D6C696E616C636F2C64633D746573748006736563726574'.
	self assert: encoded equals: expected
]

{ #category : 'tests' }
BERDecoderTest >> testDelRequest [
	| request encoded expected |
	request := LDAPDeleteRequest new name: 'cn=test2,dc=linalco,dc=test'.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '30200201014A1B636E3D74657374322C64633D6C696E616C636F2C64633D74657374'.
	self assert: encoded equals: expected

]

{ #category : 'tests' }
BERDecoderTest >> testModifyRequest [
	| request encoded expected ops |
	ops :=  { 
			LDAPSetAttributeChange new description: 'sn'; values: { 'test5sn' . 'foo' . 'bar'}; yourself.
			LDAPAddAttributeChange new description: 'description'; values: {'rchueo'}; yourself }.
									
	request := LDAPModifyRequest new name: 'cn=test5,dc=linalco,dc=test'; operations: ops.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '3062020101665D041B636E3D74657374352C64633D6C696E616C636F2C64633D74657374303E301E0A010230190402736E311304077465737435736E0403666F6F0403626172301C0A01003017040B6465736372697074696F6E3108040672636875656F'.
	self assert: encoded equals: expected

]

{ #category : 'tests' }
BERDecoderTest >> testSearchRequest [
	| request encoded hex expected |
	request := LDAPSearchRequest new 
		base: 'dc=linalco, dc=test'; 
		scope: LDAPWholeSubtreeScope new; 
		derefAliases: LDAPNeverDeferAliases new; 
		filter: (LDAPFilter with: 'objectclass' ).
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	hex := encoded asString asHex.

	expected := self formatWithHex: '30380201016333041364633D6C696E616C636F2C2064633D746573740A01020A0100020100020100010100870B6F626A656374636C6173733000'.
	self assert: hex equals: expected

]
