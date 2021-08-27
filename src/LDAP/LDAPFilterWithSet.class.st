"
Filter with a set of filters
"
Class {
	#name : #LDAPFilterWithSet,
	#superclass : #BERSet,
	#category : #'LDAP-Filters'
}

{ #category : #accessing }
LDAPFilterWithSet >> addFilter: aFilter [
	self addElement: aFilter
]
