"
I am a BER composite element. I can be either a BERSequence or a BERSet.
"
Class {
	#name : 'BERConstruct',
	#superclass : 'BERElement',
	#traits : 'TIsEmpty',
	#classTraits : 'TIsEmpty classTrait',
	#instVars : [
		'elements'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'adding' }
BERConstruct >> addAll: aCollection [
	elements addAllLast: aCollection.
]

{ #category : 'accessing' }
BERConstruct >> addElement: anElement [
	elements addLast: anElement
]

{ #category : 'converting' }
BERConstruct >> asArray [
	^ elements asArray
]

{ #category : 'converting' }
BERConstruct >> asSet [
	^ elements asSet
]

{ #category : 'enumerating' }
BERConstruct >> collect: aBlock [

	^ elements collect: aBlock 
]

{ #category : 'encoding' }
BERConstruct >> decode: aStream length: aLength with: aDecoder [
	| elementLen part |
	self removeAll.
	elementLen := aLength.
	[elementLen > 0]
		whileTrue: [
			part := aDecoder readElementFrom: aStream in: self.
			elementLen := elementLen - part totalLength.
			self addElement: part.
		].
]

{ #category : 'enumerating' }
BERConstruct >> do: aBlock [

	elements do: aBlock
]

{ #category : 'initialization' }
BERConstruct >> initialize [
	super initialize.
	elements := OrderedCollection new
]

{ #category : 'testing' }
BERConstruct >> isConstruct [ 

	^ true
]

{ #category : 'testing' }
BERConstruct >> isEmpty [
	^ elements isEmpty
]

{ #category : 'accessing' }
BERConstruct >> length [
	^ elements inject: 0 into: [ :sum :each | sum + each totalLength ]
]

{ #category : 'printing' }
BERConstruct >> printOn: aStream [
	super printOn: aStream.
	aStream space.
	elements printElementsOn: aStream.
]

{ #category : 'removing' }
BERConstruct >> removeAll [

	elements removeAll
]

{ #category : 'accessing' }
BERConstruct >> size [ 

	^ elements size
]

{ #category : 'storing' }
BERConstruct >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
 		nextPutAll: ' new addAll: { '.
		
	elements do: [ :each | each storeOn: aStream ] 
		separatedBy: [ aStream nextPutAll: '. ' ].

 	aStream
 		nextPutAll: ' }; yourself)'

]

{ #category : 'writing' }
BERConstruct >> writeBodyOn: aStream [
	elements do: [ :element | element writeOn: aStream  ].

]
