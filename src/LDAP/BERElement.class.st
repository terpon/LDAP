"
A BERElement is a datatype in the BER encoding (Basic Encoding Rules)
"
Class {
	#name : 'BERElement',
	#superclass : 'Object',
	#classVars : [
		'UniversalTags'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'utilities' }
BERElement class >> lengthLength: anInteger [
	| octets |
	
	"short definite length"
	anInteger < 128 ifTrue: [ ^ 1 ].
		
	"long definite length"
	octets := anInteger bytesCount.
	
	"number of bytes plus the length in one byte"
	^ octets + 1
]

{ #category : 'accessing' }
BERElement class >> tagValue [
	self subclassResponsibility
]

{ #category : 'writing' }
BERElement class >> writeLength: aLength on: aStream [
	| lengthLength octets remainderValue |
	lengthLength := self lengthLength: aLength.
	
	lengthLength == 1 ifTrue: [ aStream nextPut: aLength asCharacter. ^ self ].

	octets := ByteArray new: lengthLength.
	octets at: 1 put: ((lengthLength - 1) bitOr: 16r80).
	remainderValue := aLength.
	lengthLength to: 2 by: -1 do: [ :octetsIndex |
		octets at: octetsIndex  put: (remainderValue bitAnd: 16rFF).
		remainderValue := remainderValue bitShift: -8.
	].

	aStream nextPutAll: octets asString.
]

{ #category : 'encoding' }
BERElement >> decode: aStream length: anInteger with: aDecoder [
	self subclassResponsibility
]

{ #category : 'accessing' }
BERElement >> elements [
	^ #()
]

{ #category : 'accessing' }
BERElement >> length [
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
BERElement >> newElementFrom: aTagValue [
"Default implementation."
	^ nil
]

{ #category : 'accessing' }
BERElement >> tagValue [ 
	^ self class tagValue
]

{ #category : 'accessing' }
BERElement >> totalLength [
	| tagLength bodyLength lengthLength |
	tagLength := 1.
	bodyLength := self length.
	lengthLength := self class lengthLength: bodyLength.
	^ tagLength + lengthLength + bodyLength
]

{ #category : 'accessing' }
BERElement >> value [
	^ nil
]

{ #category : 'writing' }
BERElement >> writeBodyOn: aStream [
	self subclassResponsibility
]

{ #category : 'writing' }
BERElement >> writeOn: aStream [
	aStream nextPut: self tagValue asCharacter.
	self class writeLength: self length on: aStream.
	self writeBodyOn: aStream

]
