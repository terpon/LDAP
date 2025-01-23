"
I am the server result from a bind request.
"
Class {
	#name : 'LDAPBindResult',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPBindResult class >> tagValue [
	^ 16r61
]
