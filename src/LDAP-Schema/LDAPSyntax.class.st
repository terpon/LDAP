"
I represent attribute syntaxes
"
Class {
	#name : 'LDAPSyntax',
	#superclass : 'LDAPObject',
	#instVars : [
		'description',
		'notHumanReadable',
		'binaryTransferRequired'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'accessing' }
LDAPSyntax >> binaryTransferRequired: aBoolean [

	binaryTransferRequired := aBoolean
]

{ #category : 'accessing' }
LDAPSyntax >> description [

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPSyntax >> description: anObject [

	description := anObject
]

{ #category : 'testing' }
LDAPSyntax >> doesNotRequireBinaryTransfer [

	^ self requireBinaryTransfer not
]

{ #category : 'accessing - extension' }
LDAPSyntax >> extensions: aDictionary [

	aDictionary at: 'X-BINARY-TRANSFER-REQUIRED' ifPresent: [ :value | value = 'TRUE' ifTrue: [ binaryTransferRequired := true ] ].
	aDictionary at: 'X-NOT-HUMAN-READABLE' ifPresent: [ :value | value = 'TRUE' ifTrue: [ notHumanReadable := true ] ].	
]

{ #category : 'testing' }
LDAPSyntax >> isHumanReadable [

	^ self isNotHumanReadable not
]

{ #category : 'testing' }
LDAPSyntax >> isNotHumanReadable [

	^ notHumanReadable ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPSyntax >> notHumanReadable: aBoolean [

	notHumanReadable := aBoolean 
]

{ #category : 'printing' }
LDAPSyntax >> printOn: aStream [

	aStream nextPutAll: 'a '; nextPutAll: self className; space.
	self description ifNotEmpty: [ :d | aStream nextPut: $'; nextPutAll: d; nextPut: $'; space ]. 
	aStream nextPut: $(; nextPutAll: oid; nextPut: $).
]

{ #category : 'testing' }
LDAPSyntax >> requireBinaryTransfer [

	^ binaryTransferRequired ifNil: [ false ]
]
