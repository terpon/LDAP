Class {
	#name : 'BEROctetStringTest',
	#superclass : 'BERDecoderTest',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
BEROctetStringTest >> testEmpty [

	| ber1 ber2 |
	ber1 := BEROctetString new.
	ber2 := BEROctetString new from: ''.

	self assert: ber1 encoded equals: ber2 encoded
]

{ #category : 'tests' }
BEROctetStringTest >> testEncoded [

	| ber output test expected |

	test := { 'hello'. 5. '040568656C6C6F' }.

	ber := BEROctetString new from: test first.
	output := ber encoded asHex.
	expected := self formatWithHex: test third.
	self assert: output equals: expected
]

{ #category : 'tests' }
BEROctetStringTest >> testUnicode [

	| ber output test expected |

	test := { 'Ніна Dvořák'. 2 + 19. '0413D09DD196D0BDD0B0E280AF44766FC599C3A16B' }.

	ber := BEROctetString new from: test first.
	self assert: ber encoded size equals: test second.
	
	output := ber encoded asHex.
	expected := self formatWithHex: test third.
	self assert: output equals: expected
]

{ #category : 'tests' }
BEROctetStringTest >> testUnicode2 [

	| ber encoded output test |

	test := '久保田 Ђорђе माधुरी'.

	ber := BEROctetString new from: test.
	encoded := ber encoded.
	output := BERDecoder new readFrom: encoded readStream.
	
	self assert: output class equals: BEROctetString.
	self assert: output asString equals: test.
]
