Class {
	#name : #LDAPSearchPartialResult,
	#superclass : #LDAPAbstractResult,
	#category : #'LDAP-Results'
}

{ #category : #'error handling' }
LDAPSearchPartialResult >> checkForExceptions [
"No exception for those results"
	^ self
]

{ #category : #testing }
LDAPSearchPartialResult >> isEndMarker [
	^ false
]

{ #category : #accessing }
LDAPSearchPartialResult >> matchedDN [
	^ self subclassResponsibility
]
