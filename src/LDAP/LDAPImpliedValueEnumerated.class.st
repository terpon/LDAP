Class {
	#name : 'LDAPImpliedValueEnumerated',
	#superclass : 'BEREnumerated',
	#category : 'LDAP-Enumerated',
	#package : 'LDAP',
	#tag : 'Enumerated'
}

{ #category : 'storing' }
LDAPImpliedValueEnumerated >> storeOn: aStream [

 	aStream
 		nextPut: $(;
 		nextPutAll: self className;
 		nextPutAll: ' new)'
]

{ #category : 'accessing' }
LDAPImpliedValueEnumerated >> value: anInteger [
	^ self shouldNotImplement 
]
