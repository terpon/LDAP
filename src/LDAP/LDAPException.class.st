"
Common superclass for LDAP exceptions
"
Class {
	#name : 'LDAPException',
	#superclass : 'Error',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'private - testing' }
LDAPException >> isResumable [

	^ true
]
