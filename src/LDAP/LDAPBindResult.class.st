"
I am the server result from a `LDAPBindRequest`.
"
Class {
	#name : 'LDAPBindResult',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
}

{ #category : 'accessing' }
LDAPBindResult class >> tagValue [
	^ 16r61
]
