"
LDAPDelRequest is the process to delete an entry in the LDAP directory.
"
Class {
	#name : 'LDAPDeleteRequest',
	#superclass : 'LDAPString',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPDeleteRequest class >> tagValue [
	^ 16r4A "Application 10"
]

{ #category : 'accessing' }
LDAPDeleteRequest >> name [
	^ self content
]

{ #category : 'accessing' }
LDAPDeleteRequest >> name: aDn [
	self content: aDn
]
