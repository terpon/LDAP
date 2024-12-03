"
I am an octet string element to enforce and help implementation of [RFC4514](https://docs.ldap.com/specs/rfc4514.txt) (Lightweight Directory Access Protocol: String Representation of Distinguished Name).
"
Class {
	#name : 'LDAPString',
	#superclass : 'BEROctetString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'accessing' }
LDAPString >> content [
"Override BER version to always return a string"
	^ self asString
]

{ #category : 'accessing' }
LDAPString >> content: aString [
"Override BER version to always accept a string and store it as UTF8 byte array"
	self from: aString
]

{ #category : 'converting' }
LDAPString >> stripBase: aString [
	| base |
	base := self content.
	"Simplified version, non-canonical RDNs can be more tricky"
	(aString endsWith: base) ifFalse: [ ^ aString ].
	(aString size <= base size) ifTrue: [ ^ '' ].
	((aString at: (aString size - base size)) = $,) ifFalse: [ ^ aString ].
	
	^ aString copyFrom: 1 to: (aString size - base size - 1)
]
