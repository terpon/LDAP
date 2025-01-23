"
I am signaled when there is a problem with a distinguised name in the request.
"
Class {
	#name : 'LDAPNameException',
	#superclass : 'LDAPResultException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPNameException >> resultType: aCode [

	aCode = 32 ifTrue: [ ^'LDAP no such object' ].
	aCode = 33 ifTrue: [ ^'LDAP alias problem' ].
	aCode = 34 ifTrue: [ ^'LDAP invalid DN syntax' ].
	aCode = 35 ifTrue: [ ^'LDAP undefined isLeaf' ].
	aCode = 36 ifTrue: [ ^'LDAP alias dereferencing problem' ].
	^super resultType: aCode 
]
