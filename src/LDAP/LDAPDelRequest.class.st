"
LDAPDelRequest is the process to delete an entry in the LDAP directory.
"
Class {
	#name : 'LDAPDelRequest',
	#superclass : 'BEROctetString',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPDelRequest class >> tagValue [
	^ 16r4A "Application 10"
]

{ #category : 'accessing' }
LDAPDelRequest >> name: aDn [
	self value: aDn
]
