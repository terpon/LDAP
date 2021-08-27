"
BEROctetString is a string encoded in BER.
"
Class {
	#name : #BEROctetString,
	#superclass : #BERElement,
	#instVars : [
		'string'
	],
	#category : #'LDAP-BER'
}

{ #category : #accessing }
BEROctetString class >> tagValue [
	^ 4 
]

{ #category : #encoding }
BEROctetString >> decode: aStream length: aLength [
	string := (aStream next: aLength) asString
]

{ #category : #accessing }
BEROctetString >> length [ 
	^ string size
]

{ #category : #accessing }
BEROctetString >> value [ 
	^ string ifNil: [ String new ]
]

{ #category : #accessing }
BEROctetString >> value: anObject [
	string := anObject asString 
]

{ #category : #writing }
BEROctetString >> writeBodyOn: aStream [
	"theorically we should convert it to UTF8"
	aStream nextPutAll: self value.

]
