Class {
	#name : 'BERBooleanTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'test data' }
BERBooleanTest >> booleanTestSet [

	^ #(
		  ( 0     '010100' )
		  ( 1     '0101FF' )
		  ( 255  '0101FF' )
		  ( 1000 '0101FF' )
		  ( false '010100' )
		  ( true  '0101FF' )
		)

]

{ #category : 'tests' }
BERBooleanTest >> testEncoded [

	| ber output expected |
	ber := BERBoolean new.

	self booleanTestSet do: [ :test |
		ber content: test first.
		output := ber encoded asHex.
		expected := self formatWithHex: test second.
		self assert: output equals: expected
	]
]
