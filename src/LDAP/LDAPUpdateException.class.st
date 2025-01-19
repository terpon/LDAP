"
Problem with updating an entry
"
Class {
	#name : 'LDAPUpdateException',
	#superclass : 'LDAPResultException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPUpdateException >> resultType: aCode [

	aCode = 64 ifTrue: [ ^'LDAP naming violation' ].
	aCode = 65 ifTrue: [ ^'LDAP object class violation' ].
	aCode = 66 ifTrue: [ ^'LDAP not allowed on non leaf' ].
	aCode = 67 ifTrue: [ ^'LDAP not allowed on RDN' ].
	aCode = 68 ifTrue: [ ^'LDAP entry already exists' ].
	aCode = 69 ifTrue: [ ^'LDAP object class mods prohibited' ].
	^super resultType: aCode 
]
