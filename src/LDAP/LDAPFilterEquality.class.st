"
I will match any entry that contains a given value for an attribute with a specified attribute description.
"
Class {
	#name : 'LDAPFilterEquality',
	#superclass : 'LDAPFilterWithValueAssertion',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterEquality class >> tagValue [
	^ 16rA3 "Context 3"
]
