"
A BERPrimitive holds a single value. It is used to represent non constructed types (BERConstruct).
"
Class {
	#name : 'BERPrimitive',
	#superclass : 'BERElement',
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERPrimitive >> content [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
BERPrimitive >> content: anObject [

	self subclassResponsibility
]

{ #category : 'printing' }
BERPrimitive >> printOn: aStream [
	self content printOn: aStream.
]

{ #category : 'storing' }
BERPrimitive >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
 		nextPutAll: ' new content: '.
	self content storeOn: aStream.
	aStream
		nextPut: $)

]
