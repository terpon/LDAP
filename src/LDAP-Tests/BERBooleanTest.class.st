Class {
	#name : 'BERBooleanTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
BERBooleanTest >> testEncoded [

	| ber output expected |
	ber := BERBoolean new.

	self booleanTestSet do: [ :test |
		ber value: test first.
		output := ber encoded asHex.
		expected := self formatWithHex: test second.
		self assert: output equals: expected
	]
]
