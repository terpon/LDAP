"
I represent the operation value to add one or more attribute values to an entry.
"
Class {
	#name : 'LDAPAddAttributesOperation',
	#superclass : 'LDAPModifyOperation',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPAddAttributesOperation >> initialize [ 
	super initialize.
	integer := 0. "Add"
]

{ #category : 'accessing' }
LDAPAddAttributesOperation >> name [
	^ 'add'
]
