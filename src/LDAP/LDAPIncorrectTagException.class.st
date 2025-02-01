"
I am an exception signal when decoding a byte stream into BER elements if the tag value does not match the element.
"
Class {
	#name : 'LDAPIncorrectTagException',
	#superclass : 'LDAPDecoderException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'signalling' }
LDAPIncorrectTagException class >> signalWith: aTagValue expected: anotherTagValue [

	^ self signal: ('Invalid tag ', aTagValue asString, '. Expected: ', anotherTagValue asString)
]
