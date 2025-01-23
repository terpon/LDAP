"
I am a request to modify the attributes of an entry.
"
Class {
	#name : 'LDAPModifyRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPModifyRequest class >> tagValue [
	^ 16r66 "Application 6"
]

{ #category : 'adding' }
LDAPModifyRequest >> addOperation: anOp [
	elements second addElement: anOp
]

{ #category : 'adding' }
LDAPModifyRequest >> delete: anAttribute [
	| op |
	op := LDAPDeleteAttributeChange new.
	op description: anAttribute.
	self addOperation: op
]

{ #category : 'adding' }
LDAPModifyRequest >> description: anAttribute add: aCollection [
	| op |
	op := LDAPAddAttributeChange new.
	op description: anAttribute.
	op values: aCollection.		
	self addOperation: op
]

{ #category : 'adding' }
LDAPModifyRequest >> description: anAttribute delete: aCollection [
	| op |
	op := LDAPDeleteAttributeChange new.
	op description: anAttribute.
	op values: aCollection.		
	self addOperation: op
]

{ #category : 'initialization' }
LDAPModifyRequest >> initialize [ 
	super initialize.
	
	self addElement: (LDAPString new).
	self addElement: (BERSequence new).

]

{ #category : 'accessing' }
LDAPModifyRequest >> name [
	^ elements first asString
]

{ #category : 'accessing' }
LDAPModifyRequest >> name: aDn [
	elements first content: aDn
]

{ #category : 'accessing' }
LDAPModifyRequest >> operations [
	^ elements second

]

{ #category : 'accessing' }
LDAPModifyRequest >> operations: someModifyingOps [

	elements second removeAll.
	someModifyingOps do: [ :each | self addOperation: each ].

]

{ #category : 'adding' }
LDAPModifyRequest >> set: anAttribute to: aString [
	| op |
	op := LDAPSetAttributeChange new.
	op description: anAttribute.
	op values: aString.		
	self addOperation: op
]
