"
A BERPrimitive holds a single value. It is used to represent non constructed types (BERConstruct).
"
Class {
	#name : 'BERPrimitive',
	#superclass : 'BERElement',
	#instVars : [
		'value'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'printing' }
BERPrimitive >> printOn: aStream [
	self value printOn: aStream.
]
