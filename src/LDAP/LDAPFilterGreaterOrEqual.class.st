"
I will match any entry that contains at least one value for a specified attribute that is greater than or equal to a given value.
"
Class {
	#name : 'LDAPFilterGreaterOrEqual',
	#superclass : 'LDAPFilterWithValueAssertion',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterGreaterOrEqual class >> tagValue [
	^ 16rA5 "Context 5"	
]
