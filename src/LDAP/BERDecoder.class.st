"
I decode a stream into a BERElement instance.

I am responsible for creation of universal class elements.
I defer to my application instance variable for application class elements.
For constructed types, I query the constructed instance for context class elements.
"
Class {
	#name : 'BERDecoder',
	#superclass : 'Object',
	#instVars : [
		'application'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'testing' }
BERDecoder class >> isApplication: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16r40
]

{ #category : 'testing' }
BERDecoder class >> isConstructed: aTagValue [
	^ (aTagValue bitAnd: 16r20) = 16r20
]

{ #category : 'testing' }
BERDecoder class >> isContext: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16r80
]

{ #category : 'testing' }
BERDecoder class >> isPrivate: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 16rC0
]

{ #category : 'testing' }
BERDecoder class >> isUniversal: aTagValue [
	^ (aTagValue bitAnd: 16rC0) = 0
]

{ #category : 'accessing' }
BERDecoder >> application: anObject [
	application := anObject
]

{ #category : 'private - creation' }
BERDecoder >> newElementWith: aTagValue in: aParent [
"Create an element from the context"
	| element |
	"Use parent element as context if any"
	element := aParent ifNotNil: [ element := aParent newElementFrom: aTagValue ].
	"Then try to create an application-specific element from the application"
	(element isNil and: [ application isNotNil ]) ifTrue: [ element := application newApplicationElementFrom: aTagValue ].
	"Then try to create a universal element from its tag"
	element ifNil: [ element := BERElement newUniversalElementFrom: aTagValue ].
	"Finally bail out"
	element ifNil: [ element := self newUnknownElementFrom: aTagValue ].
	^ element

]

{ #category : 'private - creation' }
BERDecoder >> newUnknownElementFrom: anInteger [
"Create a BER unknown element and signal error."
	LDAPException signal: ('Invalid tag', anInteger asString).
	^ BERUnknownElement new tag: anInteger

]

{ #category : 'private - reading' }
BERDecoder >> read: anElement from: aStream [
"Decode an already existing element from a stream"
	| firstByte length |
	firstByte := aStream next asInteger.
	(firstByte = anElement class tagValue) ifFalse: [ LDAPIncorrectTagException signal: 'inconsitent tag ', firstByte asString ].
	length := self readLengthFrom: aStream.
	anElement decode: aStream length: length with: self
]

{ #category : 'private - reading' }
BERDecoder >> readElementFrom: aStream in: aParent [
"Create a BER element from a stream"
	| firstByte element |
	firstByte := aStream peek asInteger.
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	element := self newElementWith: firstByte in: aParent.
	self read: element from: aStream.
	^ element

]

{ #category : 'reading' }
BERDecoder >> readFrom: aStream [
"Start decoding from a stream."
	^ self readElementFrom: aStream in: nil
]

{ #category : 'private - reading' }
BERDecoder >> readLengthFrom: aStream [
	| length octets firstOctet |
	
	firstOctet := aStream next asInteger.
	
	"short definite length"
	firstOctet < 128 ifTrue: [ ^ firstOctet ].
		
	"long definite length"
	octets := aStream next: (firstOctet bitAnd: 16r7F).
	length := octets contents inject: 0 into: [:injectedValue :each | (injectedValue bitShift: 8) + (each asInteger)].
		
	^ length			
]
