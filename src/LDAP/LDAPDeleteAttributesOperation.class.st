"
I represent the operation value to remove one or more attribute values from an entry. 
"
Class {
	#name : 'LDAPDeleteAttributesOperation',
	#superclass : 'LDAPModifyOperation',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPDeleteAttributesOperation >> initialize [ 
	super initialize.
	integer := 1. "Delete"
]

{ #category : 'accessing' }
LDAPDeleteAttributesOperation >> name [
	^ 'delete'
]
