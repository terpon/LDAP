"
Pseudo BER sequence for modification operations
"
Class {
	#name : #LDAPModifyOp,
	#superclass : #BERSequence,
	#instVars : [
		'attr',
		'values'
	],
	#category : #'LDAP-Elements'
}

{ #category : #accessing }
LDAPModifyOp >> attr [
	^ elements first value
]

{ #category : #accessing }
LDAPModifyOp >> attr: aString [
	elements second description: aString
]

{ #category : #initialization }
LDAPModifyOp >> initialize [ 
	super initialize.
	
	self addElement: (BEREnumerated new).
	self addElement: (LDAPPartialAttribute new).

]

{ #category : #'instance creation' }
LDAPModifyOp >> operation: anInteger [
	elements first value: anInteger 
]

{ #category : #printing }
LDAPModifyOp >> operationName [ 
	| operation |
	operation := elements first value.
	operation = 0 ifTrue: [ ^ 'add' ].
	operation = 1 ifTrue: [ ^ 'delete' ].
	operation = 2 ifTrue: [ ^ 'replace' ].
	^ 'unknown'.
]

{ #category : #printing }
LDAPModifyOp >> printOn: aStream [
	aStream nextPutAll: self class name, self operationName, '(', self attr, ': ', self values asArray, ')'. 
]

{ #category : #accessing }
LDAPModifyOp >> values [
	elements second values
]

{ #category : #accessing }
LDAPModifyOp >> values: aCollection [
	elements second values: aCollection
]
