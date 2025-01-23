"
I am an abstract class used to represent a single value encoded as a BERElement.

Multiple values must be encoded as childen of a constructed type (BERConstruct).
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
