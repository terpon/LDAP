"
I am signaled when a tag byte is not recognized in the stream.
"
Class {
	#name : 'LDAPUnknownTagException',
	#superclass : 'LDAPDecoderException',
	#category : 'LDAP-Exceptions',
	#package : 'LDAP',
	#tag : 'Exceptions'
}

{ #category : 'signalling' }
LDAPUnknownTagException class >> signalWith: aTagValue [

	^ self signal: ('Unknown tag ', aTagValue asString)
]
