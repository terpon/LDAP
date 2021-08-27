"
A present filter
"
Class {
	#name : #LDAPFilterPresent,
	#superclass : #BEROctetString,
	#category : #'LDAP-Filters'
}

{ #category : #'instance creation' }
LDAPFilterPresent class >> having: anAttrType [
	^ self new value: anAttrType

]

{ #category : #accessing }
LDAPFilterPresent class >> tagValue [
	^ 16r87 "Context 7"
]
