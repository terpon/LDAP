"
I represent a distinguished name string.
"
Class {
	#name : 'LDAPName',
	#superclass : 'LDAPString',
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'helper' }
LDAPName class >> firstAsPairs: aDN [
	
	| rdn attrs |
	rdn := self firstName: aDN.
	rdn ifEmpty: [ ^ #() ].
	attrs := $+ split: rdn.
	^ attrs collect: [ :attr | $= split: attr ]
]

{ #category : 'helper' }
LDAPName class >> firstName: aDN [
	
	| firstEqual |
	firstEqual := aDN indexOf: $, startingAt: 1 ifAbsent: [ ^ aDN ].
	^ aDN copyFrom: 1 to: firstEqual-1
]

{ #category : 'helper' }
LDAPName class >> parentOf: aDN [
	
	| firstEqual |
	firstEqual := aDN indexOf: $, startingAt: 1 ifAbsent: [ ^ '' ].
	^ aDN copyFrom: firstEqual+1 to: aDN size 
]
