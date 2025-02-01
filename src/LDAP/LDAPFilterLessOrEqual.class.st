"
I will match any entry that contains at least one value that is less than or equal to a given value.
"
Class {
	#name : 'LDAPFilterLessOrEqual',
	#superclass : 'LDAPFilterWithValueAssertion',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterLessOrEqual class >> tagValue [
	^ 16rA6 "Context 6"
]
