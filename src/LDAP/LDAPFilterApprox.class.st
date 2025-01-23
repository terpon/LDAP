"
I will match any entry that has a specified attribute with at least one value that is approximately equal to a given value.

Official LDAP specifications are vague as to what exactly “approximately equal to” means, and leave it up to the individual server implementations.
"
Class {
	#name : 'LDAPFilterApprox',
	#superclass : 'LDAPFilterWithValueAssertion',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'accessing' }
LDAPFilterApprox class >> tagValue [
	^ 16rA8 "Context 8"
]
