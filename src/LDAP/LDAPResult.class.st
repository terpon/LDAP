"
Result of an LDAP message.
"
Class {
	#name : 'LDAPResult',
	#superclass : 'LDAPAbstractResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
}

{ #category : 'accessing' }
LDAPResult class >> tagValue [
	self subclassResponsibility
]

{ #category : 'accessing' }
LDAPResult >> diagnosticElement [
	^ elements third
]

{ #category : 'accessing' }
LDAPResult >> diagnosticMessage [
	^ self diagnosticElement value
]

{ #category : 'testing' }
LDAPResult >> isEndMarker [
	^ true
]

{ #category : 'accessing' }
LDAPResult >> matchedElement [
	^ elements second
]

{ #category : 'accessing' }
LDAPResult >> name [
"In RFC, the element is either called 'name', 'objectName' or 'matchedDN'"
	^ self matchedElement value
]

{ #category : 'instance creation' }
LDAPResult >> newElementFrom: aTagValue [
	
	(aTagValue = LDAPReferral tagValue) ifTrue: [ ^ LDAPReferral new ].

	"First element is always a result code"
	elements ifEmpty: [ ^ LDAPResultCode new ].

	^ super newElementFrom: aTagValue
]

{ #category : 'accessing' }
LDAPResult >> referralElement [
	(elements size < 4) ifTrue: [  ^ nil ].
	^ elements fourth
]

{ #category : 'accessing' }
LDAPResult >> resultCode [
	^ self resultElement value
]

{ #category : 'accessing' }
LDAPResult >> resultElement [
	^ elements first
]

{ #category : 'error handling' }
LDAPResult >> signalClass [
	| code |
	code := self resultCode.
	(code between: 16 and: 21) ifTrue: [ ^ LDAPAttrProblemException ].
	((code between: 32 and: 36) and: [ code ~= 35 ]) ifTrue: [ ^ LDAPNameProblemException ].
	(code between: 48 and: 50) ifTrue: [ ^ LDAPSecurityProblemException ].
	(code between: 51 and: 54) ifTrue: [ ^ LDAPServiceProblemException ].
	((code between: 64 and: 69) or: [ code = 71 ]) ifTrue: [ ^ LDAPUpdateProblemException ].
	
	^ LDAPException
]

{ #category : 'error handling' }
LDAPResult >> signalExceptions [
	| ex |
	self success ifTrue: [ ^ self ].

	ex := self signalClass new.
	ex signal: self resultElement printString 

]

{ #category : 'testing' }
LDAPResult >> success [ 
	^ self resultCode isZero 
]
