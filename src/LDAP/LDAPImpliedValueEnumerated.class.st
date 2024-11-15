"
I am an abstract class where each subclass represents one enumeration value that cannot (obviously) be changed
"
Class {
	#name : 'LDAPImpliedValueEnumerated',
	#superclass : 'BEREnumerated',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPImpliedValueEnumerated >> name [
	^ self subclassResponsibility
]

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
