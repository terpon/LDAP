"
Result for compare
"
Class {
	#name : 'LDAPCompareResult',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
}

{ #category : 'accessing' }
LDAPCompareResult class >> tagValue [
	^ 16r6F
	
]

{ #category : 'testing' }
LDAPCompareResult >> isMatch [
	self resultCode = 6 ifTrue: [ ^ true ].
	"self resultCode = 5 ifTrue: [ ^ false ]."
	^ false

]

{ #category : 'testing' }
LDAPCompareResult >> success [
	| code |
	code := self resultCode.	
	^ #( 0 5 6 ) includes: code
]
