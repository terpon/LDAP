"
I represent a set of values encoded in BER.

The order of my children elements are not supposed to matter.
"
Class {
	#name : 'BERSet',
	#superclass : 'BERConstruct',
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERSet class >> tagValue [
	"SET + Constructed"
	^ (17 + 32)
]
