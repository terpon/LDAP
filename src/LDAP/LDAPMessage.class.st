"
I am LDAP Message.

I am a pseudo BER Sequence. (I do not have my own application tag)
"
Class {
	#name : 'LDAPMessage',
	#superclass : 'BERSequence',
	#classVars : [
		'LdapTags'
	],
	#category : 'LDAP-Core',
	#package : 'LDAP',
	#tag : 'Core'
}

{ #category : 'class initialization' }
LDAPMessage class >> initialize [ 
"LDAP messages class initialization. Populate the knownTags variable for application elements creation."
	| classes |
	classes := BERElement allSubclasses select: [ :c | c class canPerform: #tagValue ].
	classes := classes select: [ :c | BERDecoder isApplication: c tagValue  ].
	LdapTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

{ #category : 'accessing' }
LDAPMessage >> controls [
	^ (elements size > 2) ifTrue: [ elements third elements ] ifFalse: [ #() ]
]

{ #category : 'accessing' }
LDAPMessage >> controls: aCollection [
	| controls |
	controls := LDAPControls new.
	aCollection do: [ :each | controls addElement: each ].
	(elements size > 2) ifTrue: [ elements at: 3 put: controls ] ifFalse: [ elements addLast: controls ]
]

{ #category : 'accessing' }
LDAPMessage >> id [
	^ elements first value
]

{ #category : 'accessing' }
LDAPMessage >> id: anInteger [
	elements first value: anInteger 
]

{ #category : 'initialization' }
LDAPMessage >> initialize [ 
	super initialize.
	
	self addElement: (BERInteger new). "id"
	self addElement: (BERNull new). "protocolOp"

]

{ #category : 'accessing' }
LDAPMessage >> operation [
	^ elements second
]

{ #category : 'accessing' }
LDAPMessage >> operation: anObject [
	elements at: 2 put: anObject
]

{ #category : 'accessing' }
LDAPMessage >> response [
"Alias for the second element in the sequence"
	^ self operation
]
