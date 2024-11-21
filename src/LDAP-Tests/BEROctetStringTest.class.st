Class {
	#name : 'BEROctetStringTest',
	#superclass : 'BERTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
BEROctetStringTest >> testEmpty [

	| ber1 ber2 |
	ber1 := BEROctetString new.
	ber2 := BEROctetString new value: ''.

	self assert: ber1 encoded equals: ber2 encoded
]

{ #category : 'tests' }
BEROctetStringTest >> testEncoded [

	| ber output tests expected |
	ber := BEROctetString new.

	tests := { { 'hello'. 5. '040568656C6C6F' } }.

	tests do: [ :test |
		ber value: test first.
		output := ber encoded asHex.
		expected := self formatWithHex: test third.
		self assert: output equals: expected ]
]
