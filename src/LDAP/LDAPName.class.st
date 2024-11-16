"
I am an octet string element to enforce and help implementation of [RFC4514](https://docs.ldap.com/specs/rfc4514.txt) (Lightweight Directory Access Protocol: String Representation of Distinguished Name).
"
Class {
	#name : 'LDAPName',
	#superclass : 'BEROctetString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'converting' }
LDAPName >> stripBase: aString [
	| base |
	base := self value.
	"Simplified version, non-canonical RDNs can be more tricky"
	(aString endsWith: base) ifFalse: [ ^ aString ].
	(aString size <= base size) ifTrue: [ ^ '' ].
	((aString at: (aString size - base size)) = $,) ifFalse: [ ^ aString ].
	
	^ aString copyFrom: 1 to: (aString size - base size - 1)
]
