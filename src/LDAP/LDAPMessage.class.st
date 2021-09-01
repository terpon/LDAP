"
An LDAP Message
"
Class {
	#name : #LDAPMessage,
	#superclass : #Object,
	#instVars : [
		'sequence'
	],
	#classVars : [
		'LdapTags'
	],
	#category : #'LDAP-Core'
}

{ #category : #'instance creation' }
LDAPMessage class >> id: aMessageId request: aRequest [
"Create a LDAP message"
	| mesg seq |
	mesg := self new.

	seq := BERSequence new.
	seq addElement: (BERInteger new value: aMessageId).
	seq addElement: aRequest.

	mesg sequence: seq.
	^ mesg
]

{ #category : #'class initialization' }
LDAPMessage class >> initialize [ 
"LDAP messages class initialization. Populate the knownTags variable for application elements creation."
	| classes |
	classes := BERElement allSubclasses select: [ :c | c class canPerform: #tagValue ].
	classes := classes select: #isApplication.
	LdapTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

{ #category : #'instance creation' }
LDAPMessage class >> newFrom: aStream [
"Create a BER decoder with the LDAPMessage as application"
	| decoder message ber |
	message := self new.
	decoder := BERDecoder new application: message.
	ber := decoder elementFrom: aStream.
	message sequence: ber.
	^ message
]

{ #category : #'instance creation' }
LDAPMessage >> createApplicationElement: aTagValue [
"Create a BER applicatio element from a tag value"
	| elementClass |
	elementClass := LdapTags at: aTagValue ifAbsent: [ ^ nil ].
	^ elementClass new

]

{ #category : #converting }
LDAPMessage >> encoded [
"Return the encoded message"
	^ ByteString streamContents: [ :stream | sequence writeOn: stream ]

]

{ #category : #accessing }
LDAPMessage >> id [
	^ sequence value first value
]

{ #category : #accessing }
LDAPMessage >> response [
	^ sequence value second
]

{ #category : #accessing }
LDAPMessage >> sequence: anObject [
	sequence := anObject
]
