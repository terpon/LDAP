Class {
	#name : 'BERIntegerTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
BERIntegerTest >> testDecodeLengthWith [

	self integerTestSet do: [:test | 
		|ber encoded expectedValue |
		encoded := self debugHex: test second.
		ber := BERDecoder new readFrom: encoded readStream.
		self assert: ber class equals: BERInteger.
		
		expectedValue := test first.
		self assert: ber value equals: expectedValue. 
	]

]

{ #category : 'tests' }
BERIntegerTest >> testEncoded [

	| ber output expected |
	ber := BERInteger new.

	self integerTestSet do: [ :test |
		ber value: test first.
		output := ber encoded asHex.
		expected := self formatWithHex: test second.
		self assert: output equals: expected 
	]
]
