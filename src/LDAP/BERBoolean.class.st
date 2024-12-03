"
BERBoolean is a boolean encoded in BER.
"
Class {
	#name : 'BERBoolean',
	#superclass : 'BERPrimitive',
	#instVars : [
		'boolean'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERBoolean class >> tagValue [
	^ 1
]

{ #category : 'converting' }
BERBoolean >> asBoolean [
	^ boolean ifNil: [ false ]
]

{ #category : 'accessing' }
BERBoolean >> beFalse [

	boolean := false
]

{ #category : 'accessing' }
BERBoolean >> beTrue [

	boolean := true
]

{ #category : 'accessing' }
BERBoolean >> content [ 
	^ self asBoolean
]

{ #category : 'accessing' }
BERBoolean >> content: anObject [
"Convert object to a boolean"
	anObject == true ifTrue: [ boolean := true. ^ self ].
	anObject == false ifTrue: [ boolean := false. ^ self ].
	boolean := anObject isNumber
		ifTrue: [ anObject isZero not ]
		ifFalse: [ false ].

]

{ #category : 'encoding' }
BERBoolean >> decode: aStream length: anInteger with: aDecoder [
	self content: aStream next.

]

{ #category : 'accessing' }
BERBoolean >> length [
	^ 1
]

{ #category : 'storing' }
BERBoolean >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
		nextPutAll: (self asBoolean 
			ifTrue: [ ' new beTrue)' ]
			ifFalse: [ ' new beFalse)' ])
]

{ #category : 'writing' }
BERBoolean >> writeBodyOn: aStream [
	aStream nextPut: (self asBoolean ifFalse: [ 0 ] ifTrue: [ 255 ]) asCharacter
]
