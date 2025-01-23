"
I am signlade when there is a problem with an attribute in the request.
"
Class {
	#name : 'LDAPAttributeException',
	#superclass : 'LDAPResultException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPAttributeException >> resultType: aCode [
	aCode = 16 ifTrue: [ ^'LDAP no such attribute' ].
	aCode = 17 ifTrue: [ ^'LDAP undefined attribute type' ].
	aCode = 18 ifTrue: [ ^'LDAP inappropriate matching' ].
	aCode = 19 ifTrue: [ ^'LDAP constraint violation' ].
	aCode = 20 ifTrue: [ ^'LDAP attribute or value exists' ].
	aCode = 21 ifTrue: [ ^'LDAP invalid attribute syntax' ].
	^super resultType: aCode 
]
