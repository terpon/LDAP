"
A BERPrimitive holds a single value. It is used to represent non constructed types (BERConstruct).
"
Class {
	#name : 'BERPrimitive',
	#superclass : 'BERElement',
	#instVars : [
		'value'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'printing' }
BERPrimitive >> printOn: aStream [
	self value printOn: aStream.
]

{ #category : 'storing' }
BERPrimitive >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
 		nextPutAll: ' new value: '.
	self value storeOn: aStream.
	aStream
		nextPut: $)

]

{ #category : 'accessing' }
BERPrimitive >> value [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
BERPrimitive >> value: anObject [

	self subclassResponsibility
]
