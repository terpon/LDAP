"
I am the request to delete an entry in the directory.
"
Class {
	#name : 'LDAPDeleteRequest',
	#superclass : 'LDAPName',
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
	^ self asString
]

{ #category : 'accessing' }
LDAPDeleteRequest >> name: aDn [
	self content: aDn
]
