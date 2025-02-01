"
I am the abstract class for all LDAP result messages.

I define the interface which should include:
  - success
  - signalExceptions
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
