"
Problem with security
"
Class {
	#name : 'LDAPSecurityException',
	#superclass : 'LDAPResultException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPSecurityException >> resultType: aCode [

	aCode = 48 ifTrue: [ ^'LDAP inappropriate authentication' ].
	aCode = 49 ifTrue: [ ^'LDAP invalid credentials' ].
	aCode = 50 ifTrue: [ ^'LDAP insufficient access rights' ].
	^super resultType: aCode 
]
