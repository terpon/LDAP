Class {
	#name : 'BERTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests',
	#package : 'LDAP-Tests'
}

{ #category : 'test data' }
BERTest >> booleanTestSet [

	^ #(
		  ( 0     '010100' )
		  ( 1     '0101FF' )
		  ( 255  '0101FF' )
		  ( 1000 '0101FF' )
		  ( false '010100' )
		  ( true  '0101FF' )
		)

]

{ #category : 'tools' }
BERTest >> debugHex: aString [
	| str encodedString |
	
	encodedString := WriteStream on: (String new).
	str := aString readStream.
	[ str atEnd ] whileFalse: [  
		| int |
		int := Integer readHexByteFrom: str.
		encodedString  nextPut: int asCharacter.		
	].
	^encodedString contents
]

{ #category : 'tools' }
BERTest >> formatWithHex: aString [
	| encodedString pos |
	
	encodedString := WriteStream on: (String new).
	(aString size >= 2) ifTrue: [  
		pos := 1.
		[ pos < aString size ] whileTrue: [  
			encodedString nextPutAll: '16r'.
			((aString at: pos) ~= $0) ifTrue: [ encodedString nextPut: (aString at: pos) ].
			encodedString nextPut: (aString at: pos + 1).
			pos := pos + 2.
		].
	].
	^encodedString contents
]

{ #category : 'test data' }
BERTest >> integerTestSet [
	^  #(
			( 27066 '020269BA') 
			(-27066 '02029646')
			(72 '020148' )
			(127 '02017F')
			(-128 '020180')
			(128 '02020080')
			( 0'020100' )
			( 256  '02020100')
			(4294967290 '020500FFFFFFFA')
			( 1 '020101')
			(-1'0201FF')
			( -129 '0202FF7F')
		)

]

{ #category : 'tests' }
BERTest >> testAddRequest [
	| request encoded hex expected attrs |
	"using a Dictionary could generate different encodings depending on the order of iteration."
	"we'll rely on the implementation calling associationsDo: to work with this Array."
	attrs := { 
		'objectClass' -> (OrderedCollection new addLast: 'person'; yourself).
		'cn' -> (OrderedCollection new addLast: 'test2'; yourself).
		'sn' -> (OrderedCollection new addLast: 'test2'; yourself).
	}.

	request := LDAPAddRequest new dn: 'cn=test2,dc=linalco,dc=test'; attrs: attrs.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	hex := encoded asString asHex.
	expected := self formatWithHex: '305B0201016856041B636E3D74657374322C64633D6C696E616C636F2C64633D7465737430373017040B6F626A656374436C61737331080406706572736F6E300D0402636E310704057465737432300D0402736E310704057465737432'.
	self assert: hex equals: expected
]

{ #category : 'tests' }
BERTest >> testBindRequest [
	| request encoded expected |
	request := LDAPBindRequest new username: 'cn=admin,dc=linalco,dc=test'; password: 'secret'.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '302D0201016028020103041B636E3D61646D696E2C64633D6C696E616C636F2C64633D746573748006736563726574'.
	self assert: encoded equals: expected
]

{ #category : 'tests' }
BERTest >> testBooleanEncoding [

	| ber |
	ber := BERBoolean new.

	self booleanTestSet do: [ :test | | output |
		ber value: test first.
		output := String streamContents: [ :stream | ber writeOn: stream ].
		self assert: output asHex equals: (self formatWithHex: test second)
	]
]

{ #category : 'tests' }
BERTest >> testDelRequest [
	| request encoded expected |
	request := LDAPDelRequest new dn: 'cn=test2,dc=linalco,dc=test'.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '30200201014A1B636E3D74657374322C64633D6C696E616C636F2C64633D74657374'.
	self assert: encoded equals: expected

]

{ #category : 'tests' }
BERTest >> testIntegerDecoding [

	self integerTestSet do: [:test | 
		|ber encoded expectedValue |
		encoded := ByteString streamContents: [ :s |
			| stream |
			stream := ReadStream on: test second.
			[stream atEnd] whileFalse: [ | byte |
				byte := (stream next digitValue * 16).
				byte := byte + stream next digitValue.
				s nextPut: (byte asCharacter) ].
		].
		ber := BERDecoder new readFrom: encoded readStream.
		self assert: ber class equals: BERInteger.
		
		expectedValue := test first.
		self assert: ber value equals: expectedValue. 
	]

]

{ #category : 'tests' }
BERTest >> testIntegerEncoding [

	| ber output expected |
	ber := BERInteger new.

	self integerTestSet do: [ :test |
		ber value: test first.
		output := String streamContents: [ :stream | ber writeOn: stream ].
		expected := self formatWithHex: test second.
		self assert: output asHex equals: expected 
	]
]

{ #category : 'tests' }
BERTest >> testModifyRequest [
	| request encoded expected ops |
	ops :=  { 
			LDAPAttrModifier set: 'sn' to: { 'test5sn' . 'foo' . 'bar'}.
			LDAPAttrModifier addTo: 'description' values: {'rchueo'} }.
									
	request := LDAPModifyRequest new dn: 'cn=test5,dc=linalco,dc=test'; ops: ops.
	encoded := (LDAPMessage new id: 1; operation: request) encoded.
	encoded := encoded asString asHex.

	expected := self formatWithHex: '3062020101665D041B636E3D74657374352C64633D6C696E616C636F2C64633D74657374303E301E0A010230190402736E311304077465737435736E0403666F6F0403626172301C0A01003017040B6465736372697074696F6E3108040672636875656F'.
	self assert: encoded equals: expected

]

{ #category : 'tests' }
BERTest >> testOctetStringEncoding [

	| ber stream tests expected |
	ber := BEROctetString new.
	stream := ReadWriteStream on: String new.

	tests := { { 'hello'. 5. '040568656C6C6F' } }.

	tests do: [ :test |
		stream resetToStart.
		ber value: test first.
		ber writeOn: stream.
		expected := self formatWithHex: (test at: 3).
		self assert: stream contents asString asHex equals: expected ]
]

{ #category : 'tests' }
BERTest >> testSearchRequest [
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

{ #category : 'tests' }
BERTest >> testSequenceEncoding [
	|ber0 ber1 ber2 result expected |
	ber0 := BERSequence new.
	ber1 := BERInteger new value: 17.
	ber2 := BERInteger new value: 170.
	
	ber0 addElement: ber1.
	ber0 addElement: ber2.

	result := String streamContents: [ :stream | ber0 writeOn: stream ].
	expected := self formatWithHex: '3007020111020200AA'.
	self assert: result asHex equals: expected


]
