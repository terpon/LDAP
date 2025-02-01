"
I am an abstract filter containing two octet strings: the first being the attribute description, and the second the assertion value.
"
Class {
	#name : 'LDAPFilterWithValueAssertion',
	#superclass : 'BERSequence',
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterWithValueAssertion >> assertionValue [ 
	^ elements second content
]

{ #category : 'accessing' }
LDAPFilterWithValueAssertion >> assertionValue: aString [
	elements second content: aString
]

{ #category : 'accessing' }
LDAPFilterWithValueAssertion >> description [ 
	^ elements first content
]

{ #category : 'accessing' }
LDAPFilterWithValueAssertion >> description: aString [
	elements first content: aString
]

{ #category : 'conversion' }
LDAPFilterWithValueAssertion >> initialize [ 
	super initialize.

	self
		addElement: (LDAPString new);
		addElement: (LDAPString new).

]
