"
Problem with service
"
Class {
	#name : 'LDAPServiceException',
	#superclass : 'LDAPResultException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPServiceException >> resultType: aCode [

	aCode = 51 ifTrue: [ ^'LDAP service busy' ].
	aCode = 52 ifTrue: [ ^'LDAP service unavailable' ].
	aCode = 53 ifTrue: [ ^'LDAP service unwilling to perform' ].
	aCode = 54 ifTrue: [ ^'LDAP service loop detected' ].
	^super resultType: aCode 
]
