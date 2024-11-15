"
LDAPAddRequest is the process to add a new entry in the LDAP directory.

"
Class {
	#name : 'LDAPAddRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPAddRequest class >> tagValue [
	^ 16r68 "Application 8"
]

{ #category : 'adding' }
LDAPAddRequest >> addAttribute: aPartialAttribute [
	elements second addElement: aPartialAttribute
]

{ #category : 'accessing' }
LDAPAddRequest >> at: aDescription put: someValues [

	self attributes at: aDescription put: someValues
]

{ #category : 'accessing' }
LDAPAddRequest >> attributes [
	^ elements second
]

{ #category : 'accessing' }
LDAPAddRequest >> attributes: aDictionary [
	elements second attributes: aDictionary 

]

{ #category : 'initialization' }
LDAPAddRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new).
	self addElement: (LDAPPartialAttributeList new).

]

{ #category : 'accessing' }
LDAPAddRequest >> name: aDn [
	elements first value: aDn
]

{ #category : 'removing' }
LDAPAddRequest >> removeAll [ 
	elements second removeAll
]
