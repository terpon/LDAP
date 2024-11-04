"
LDAPDelRequest is the process to delete an entry in the LDAP directory.
"
Class {
	#name : 'LDAPDelRequest',
	#superclass : 'BEROctetString',
	#category : 'LDAP-Requests',
	#package : 'LDAP',
	#tag : 'Requests'
}

{ #category : 'accessing' }
LDAPDelRequest class >> tagValue [
	^ 16r4A "Application 10"
]

{ #category : 'accessing' }
LDAPDelRequest >> dn: aDn [
	self value: aDn
]
