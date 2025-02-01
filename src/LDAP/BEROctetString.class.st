"
I represent an array of bytes.

I am often used to store strings, but I can be used to store arbitrary blobs of data.
"
Class {
	#name : 'BEROctetString',
	#superclass : 'BERPrimitive',
	#instVars : [
		'data'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : 'converting' }
BEROctetString >> asString [ 
	^ data ifNil: [ '' ] ifNotNil: [ :s | s utf8Decoded ]
]

{ #category : 'accessing' }
BEROctetString >> content [
	"Do not UTF-8 decode me by default. Use asString for that"
	^ data ifNil: [ #[] ]
]

{ #category : 'accessing' }
BEROctetString >> content: anObject [
"To store a String, use from: message"
	data := anObject asByteArray
]

{ #category : 'encoding' }
BEROctetString >> decode: aStream length: aLength with: aDecoder [
	data := (aStream next: aLength) asByteArray
]

{ #category : 'converting' }
BEROctetString >> from: aString [
	"Value is stored as an UTF-8 encoded byte array"
	data := aString asString utf8Encoded
]

{ #category : 'inspecting' }
BEROctetString >> inspectionString [
	<inspectorPresentationOrder: -10 title: 'Octet String'>
	
	^ self asString inspectionString 
]

{ #category : 'accessing' }
BEROctetString >> length [ 
	^ data ifNil: [ 0 ] ifNotNil: [ :s | s size ]
]

{ #category : 'writing' }
BEROctetString >> writeBodyOn: aStream [
	data ifNotNil: [ :s | s do: [ :c | aStream nextPut: c asCharacter ] ]

]
