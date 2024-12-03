"
Request to modify a distinguished name
"
Class {
	#name : 'LDAPModifyNameRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPModifyNameRequest class >> tagValue [
	^ 16r6C "Application 12"
]

{ #category : 'initialization' }
LDAPModifyNameRequest >> initialize [ 
	super initialize.
	
	self addElement: (LDAPString new). "entry"
	self addElement: (LDAPString new). "newrdn"
	self addElement: (BERBoolean new). "deleteoldrdn"

]

{ #category : 'accessing' }
LDAPModifyNameRequest >> name: aDn [
	elements first content: aDn
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> newRelativeName: aRdn [
	elements second content: aRdn
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> shouldDeleteOldRelativeName: aBoolean [
"If true existing RDN is retained as an extra attribute and value in the new entry."
	elements third content: aBoolean
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> underName: aDn [
	elements size < 4 ifTrue: [ elements addElement: (LDAPOptionalName new)].
	elements fourth content: aDn
]
