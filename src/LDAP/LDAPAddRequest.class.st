"
I am the request to add a new entry in the directory.

The list of attributes in the entry can be created as BER elements or passed as a `Dictionary`.

I enforce no rules. The user has to take care of mandatory attributes and make sure the relative distinguished name is also present in the attributes.
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
	
	self addElement: (LDAPString new).
	self addElement: (LDAPPartialAttributeList new).

]

{ #category : 'accessing' }
LDAPAddRequest >> name [
	^ elements first asString
]

{ #category : 'accessing' }
LDAPAddRequest >> name: aDn [
	elements first content: aDn
]

{ #category : 'removing' }
LDAPAddRequest >> removeAll [ 
	elements second removeAll
]
