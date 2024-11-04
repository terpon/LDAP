"
Abstract base class for partial result messages.

I override isEndMarker to notify the client that other messages will come after me.
"
Class {
	#name : 'LDAPSearchPartialResult',
	#superclass : 'LDAPAbstractResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
}

{ #category : 'testing' }
LDAPSearchPartialResult >> isEndMarker [
	^ false
]

{ #category : 'error handling' }
LDAPSearchPartialResult >> signalExceptions [
"No exception for those results"
	^ self
]

{ #category : 'testing' }
LDAPSearchPartialResult >> success [
	^ true
]
