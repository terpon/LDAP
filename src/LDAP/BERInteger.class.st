"
I represent an integer encoded in BER.

BER does not impose any limits on the magnitude of the positive or negative integer values that it can represent. However, many BER libraries do define their own bounds for the sizes of integer values that they can handle.
"
Class {
	#name : 'BERInteger',
	#superclass : 'BERPrimitive',
	#instVars : [
		'integer'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERInteger class >> tagValue [
	^ 2 
]

{ #category : 'converting' }
BERInteger >> asInteger [
	^ integer ifNil: [ 0 ]
]

{ #category : 'accessing' }
BERInteger >> content [ 
	^ self asInteger
]

{ #category : 'accessing' }
BERInteger >> content: anObject [
	integer := anObject isInteger ifTrue: [ anObject ] ifFalse: [ 0 ] 
]

{ #category : 'encoding' }
BERInteger >> decode: aStream length: aLength with: aDecoder [
	| highBit negative powerOfTwo |
	"if the high bit is set, we have negative"	
	highBit := aStream peek asInteger bitAnd: 16r80.
	negative := highBit isZero not.

	integer := 0.
	1 to: aLength do: [ :i | integer := (integer bitShift: 8) + aStream next asInteger ].

	negative ifFalse: [ ^ self ]. 

	powerOfTwo := 1 bitShift: (aLength * 8).
	integer := integer - powerOfTwo.

]

{ #category : 'inspecting' }
BERInteger >> inspectIntegerIn: aBuilder [
	<inspectorPresentationOrder: 30 title: 'Integer'> 
	^ self asInteger inspectIntegerIn: aBuilder
]

{ #category : 'accessing' }
BERInteger >> length [
"Compute the minimum size for the integer"
	| integerValue |
	integerValue := self asInteger.
	^ integerValue positive
		ifTrue: [ 
			| length msb |
			length := integerValue bytesCount.
			"if MSB is 1 we need to add an extra 0"
			msb := length * 8.
			(integerValue bitAt: msb) isZero ifTrue: [ length ] ifFalse: [ length + 1 ]
		]
		ifFalse: [
			| positive |
			positive := integerValue negated - 1.
			(positive * 2) bytesCount
		]
]

{ #category : 'writing' }
BERInteger >> writeBodyOn: aStream [
	| integerValue length octets remainderValue |
	length := self length.
	octets := ByteArray new: length.
	
	"put value into octet array, convert negatives as appropriate"
	integerValue := self asInteger.
	integerValue positive
		ifTrue: [
			remainderValue := integerValue.
			length to: 1 by: -1 do: [ :octetsIndex |
				octets at: octetsIndex put: (remainderValue bitAnd: 16rFF).
				remainderValue := remainderValue bitShift: -8 ]
		]
		ifFalse: [ 
			"negatives are in two's complement -- to convert: 1. change to positive. 2. substract 1, 3. xor everythnig"
			remainderValue := integerValue negated.
			remainderValue := remainderValue - 1.
			length to: 1 by: -1 do: [ :octetsIndex |
				octets at: octetsIndex put: ((remainderValue bitXor: 255) bitAnd: 255).
				remainderValue := remainderValue bitShift: -8.
			]
		].
	
	aStream nextPutAll: octets asString.

]
