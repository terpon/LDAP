"
BERSequence is a sequence of values encoded in BER.
"
Class {
	#name : 'BERSequence',
	#superclass : 'BERConstruct',
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'as yet unclassified' }
BERSequence class >> tagValue [
	"SEQUENCE + Constructed"
	^ (16 + 32)
]
