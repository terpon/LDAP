"
Filter with assertions about values
"
Class {
	#name : #LDAPFilterWithValueAssertion,
	#superclass : #BERSequence,
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterWithValueAssertion >> description: aString [
	elements first value: aString
]

{ #category : #conversion }
LDAPFilterWithValueAssertion >> initialize [ 
	super initialize.

	self
		addElement: (BEROctetString new);
		addElement: (BEROctetString new).

]

{ #category : #accessing }
LDAPFilterWithValueAssertion >> value: aString [
	elements second value: aString
]
