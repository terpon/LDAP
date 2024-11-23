"
I decode a stream into a BERElement instance.

I am responsible for creation of universal class elements.
I defer to my application instance variable for application class elements.
For constructed types, I query the constructed instance for context class elements.
"
Class {
	#name : 'BERDecoder',
	#superclass : 'Object',
	#classVars : [
		'UniversalTags'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'instance creation' }
BERDecoder class >> from: aStream [
"Start decoding from a stream."
	^ self new readFrom: aStream
]

{ #category : 'class initialization' }
BERDecoder class >> initialize [ 
"BERElement class initialization. Populate the knownTags variable for universal elements creation."
	| classes |
	classes := { BERInteger. BEROctetString . BERSequence. BEREnumerated. BERBoolean. BERSet. BERNull. }.
	UniversalTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

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

{ #category : 'error handling' }
BERDecoder >> check: anElement tag: aTagValue [
	| createdTag |
	createdTag := anElement tagValue.
	(aTagValue = createdTag) ifFalse: [ LDAPIncorrectTagException signalWith: createdTag expected: aTagValue ].

]

{ #category : 'private - creation' }
BERDecoder >> newElementWith: aTagValue in: aParent [
"Create an element from the context"
	| element |
	"Use parent element as context if any"
	element := aParent ifNotNil: [ element := aParent newElementFrom: aTagValue ].
	"Then try to create a universal element from its tag"
	element ifNil: [ element := self newUniversalElementFrom: aTagValue ].
	"Finally bail out"
	element ifNil: [ element := self newUnknownElementFrom: aTagValue ].
	^ element

]

{ #category : 'instance creation' }
BERDecoder >> newUniversalElementFrom: aTagValue [
"Return a BER universal element from a tag value"
	UniversalTags at: aTagValue ifPresent: [ :class | ^ class new ].
	^ nil
]

{ #category : 'private - creation' }
BERDecoder >> newUnknownElementFrom: anInteger [
"Create a BER unknown element and signal error."
	LDAPUnknownTagException signalWith: anInteger.
	(self class isConstructed: anInteger) ifTrue: [ ^ BERUnknownConstruct new tag: anInteger ].
	^ BERUnknownElement new tag: anInteger

]

{ #category : 'private - reading' }
BERDecoder >> readElementFrom: aStream in: aParent [
"Create a BER element from a stream"
	| firstByte element length |
	firstByte := aStream next asInteger.
	"Transcript show: '*** Next byte is: ', firstByte asString; cr."
	element := self newElementWith: firstByte in: aParent.
	"If no element, signal but still create a BERUnknown element"
	element 
		ifNil: [ element := self newUnknownElementFrom: firstByte ]
		ifNotNil: [ self check: element tag: firstByte].

	length := self readLengthFrom: aStream.
	element decode: aStream length: length with: self.
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
