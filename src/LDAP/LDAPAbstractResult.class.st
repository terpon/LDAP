"
Abstract class for all LDAP result messages.

It defines the interface which should include:
- checkForException
- isEndMarker
 
"
Class {
	#name : 'LDAPAbstractResult',
	#superclass : 'BERSequence',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
}

{ #category : 'testing' }
LDAPAbstractResult >> isEndMarker [
	^ self subclassResponsibility 
]

{ #category : 'error handling' }
LDAPAbstractResult >> signalExceptions [
	^ self subclassResponsibility
]

{ #category : 'testing' }
LDAPAbstractResult >> success [
	^ self subclassResponsibility 
]
