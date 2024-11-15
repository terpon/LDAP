"
Pseudo BER sequence for attributes modification operations

In LDAP Modify Request specification, I am a change sequence:
```grammar
change SEQUENCE {
          operation       ENUMERATED {
				 add     (0),
				 delete  (1),
				 replace (2),
				 ...  },
          modification    PartialAttribute }
```
"
Class {
	#name : 'LDAPAttributeChange',
	#superclass : 'BERSequence',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'testing' }
LDAPAttributeChange class >> isAbstract [

	^ self = LDAPAttributeChange
]

{ #category : 'adding' }
LDAPAttributeChange >> addValue: anObject [

	elements second addValue: anObject 
]

{ #category : 'accessing' }
LDAPAttributeChange >> description [
	^ elements second description
]

{ #category : 'accessing' }
LDAPAttributeChange >> description: aString [
	elements second description: aString
]

{ #category : 'initialization' }
LDAPAttributeChange >> initialize [ 
	super initialize.
	
	self addElement: nil.
	self addElement: (LDAPPartialAttribute new).

]

{ #category : 'printing' }
LDAPAttributeChange >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: ' (';
		nextPutAll: self description;
		nextPutAll: ': '.
	self values printElementsOn: aStream.
	aStream	nextPutAll: ')'
]

{ #category : 'accessing' }
LDAPAttributeChange >> values [
	^ elements second values
]

{ #category : 'accessing' }
LDAPAttributeChange >> values: aCollection [
	elements second values: aCollection
]
