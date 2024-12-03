Class {
	#name : 'BERIntegerTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'test data' }
BERIntegerTest >> integerTestSet [
	^  #(
			( 27066 '020269BA') 
			( -27066 '02029646')
			( 72 '020148' )
			( 127 '02017F')
			( -128 '020180')
			( 128 '02020080')
			( 0'020100' )
			( 256 '02020100')
			( 4294967290 '020500FFFFFFFA')
			( 1 '020101')
			( -1'0201FF')
			( -129 '0202FF7F')
		)

]

{ #category : 'tests' }
BERIntegerTest >> testDecodeLengthWith [

	self integerTestSet do: [:test | 
		|ber encoded expectedValue |
		encoded := self debugHex: test second.
		ber := BERDecoder from: encoded readStream.
		self assert: ber class equals: BERInteger.
		
		expectedValue := test first.
		self assert: ber content equals: expectedValue. 
	]

]

{ #category : 'tests' }
BERIntegerTest >> testEncoded [

	| ber output expected |
	ber := BERInteger new.

	self integerTestSet do: [ :test |
		ber content: test first.
		output := ber encoded asHex.
		expected := self formatWithHex: test second.
		self assert: output equals: expected 
	]
]
