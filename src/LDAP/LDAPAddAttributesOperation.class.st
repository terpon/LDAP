"
Adds one or more attribute values to an entry.
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
	value := 0. "Add"
]

{ #category : 'accessing' }
LDAPAddAttributesOperation >> name [
	^ 'add'
]
