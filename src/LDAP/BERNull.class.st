"
I am a NULL value encoded in BER.
"
Class {
	#name : 'BERNull',
	#superclass : 'BERElement',
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERNull class >> tagValue [
	^ 5
]

{ #category : 'encoding' }
BERNull >> decode: aStream length: anInteger with: aDecoder [
"Nothing to do"
]

{ #category : 'accessing' }
BERNull >> length [
	^ 0
]

{ #category : 'storing' }
BERNull >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
 		nextPutAll: ' new)'
]

{ #category : 'writing' }
BERNull >> writeBodyOn: aStream [
"Nothing to do"
]
