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
	
	self addElement: (BEROctetString new). "entry"
	self addElement: (BEROctetString new). "newrdn"
	self addElement: (BERBoolean new). "deleteoldrdn"

]

{ #category : 'accessing' }
LDAPModifyNameRequest >> name: aDn [
	elements first value: aDn
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> newRelativeName: aRdn [
	elements second value: aRdn
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> underName: aDn [
	elements size < 4 ifTrue: [ elements addElement: (LDAPOptionalName new)].
	elements fourth value: aDn
]

{ #category : 'accessing' }
LDAPModifyNameRequest >> wantToClearAttrs: aBoolean [
	elements third value: aBoolean
]
