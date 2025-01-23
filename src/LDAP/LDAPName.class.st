"
I am an octet string element to enforce and help implementation of [RFC4514](https://docs.ldap.com/specs/rfc4514.txt) (Lightweight Directory Access Protocol: String Representation of Distinguished Name).
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
	
	| firstComma |
	firstComma := aDN indexOf: $, startingAt: 1 ifAbsent: [ ^ aDN ].
	^ aDN copyFrom: 1 to: firstComma-1
]

{ #category : 'helper' }
LDAPName class >> is: aFirstString under: aSecondString [
"check if a name ends with another"
	
	^ aFirstString endsWith: aSecondString caseSensitive: false
]

{ #category : 'helper' }
LDAPName class >> parentOf: aDN [
	
	| firstEqual |
	firstEqual := aDN indexOf: $, startingAt: 1 ifAbsent: [ ^ '' ].
	^ aDN copyFrom: firstEqual+1 to: aDN size 
]

{ #category : 'helper' }
LDAPName class >> splitInThird: aDN root: aRootDN [
"Returns an array in first element the relative distinguished name, other components in second and in third the given root"
	
	| withoutRoot |
	aRootDN ifEmpty: [ ^ (self splitOnFirstName: aDN) copyWith: '' ].
	
	(aDN endsWith: aRootDN caseSensitive: false) 
		ifFalse: [ ^ (self splitOnFirstName: aDN) copyWith: '' ].

	aDN size = aRootDN size ifTrue: [ ^ { aDN. '' .'' } ].

	withoutRoot :=aDN copyFrom: 1 to: (aDN size - aRootDN size - 1).
	^ (self splitOnFirstName: withoutRoot) copyWith: aRootDN
]

{ #category : 'helper' }
LDAPName class >> splitOnFirstName: aDN [
	
	| firstComma |
	firstComma := aDN indexOf: $, startingAt: 1 ifAbsent: [ ^ { aDN. '' } ].
	^ { aDN copyFrom: 1 to: firstComma-1 . aDN copyFrom: firstComma+1 to: aDN size }
]
