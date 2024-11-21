Class {
	#name : 'BERSequenceTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
BERSequenceTest >> testEncoded [
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
