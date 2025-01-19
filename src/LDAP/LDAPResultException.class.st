"
I am an abstract exception. My subclasses are signaled from a failed LDAPResult.
"
Class {
	#name : 'LDAPResultException',
	#superclass : 'LDAPException',
	#instVars : [
		'result'
	],
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
LDAPResultException >> description [

	| message diagnostic element |
	result ifNil: [ ^super description ].

	message := self messageText.
	diagnostic := result diagnosticMessage.
	element := result name.
	^ String streamContents: [ :stream |
		stream << self resultType.
		diagnostic ifNotEmpty: [ stream << ': ' << diagnostic ].
		element ifNotEmpty: [ stream << ' (' << element << ')' ].
		message isEmptyOrNil ifFalse: [ stream << ' - ' << message ] 
	]
]

{ #category : 'accessing' }
LDAPResultException >> result [

	^ result
]

{ #category : 'accessing' }
LDAPResultException >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
LDAPResultException >> resultType [

	| code |
	code := result ifNil: [ ^ self className ] ifNotNil: [ :r | r resultCode ].
	^ self resultType: code
]

{ #category : 'accessing' }
LDAPResultException >> resultType: aCode [

	^ 'LDAP Result Error'
]
