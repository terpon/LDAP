"
I am the stream decoder for LDAP elements. I am responsible for creating application-class elements for specific tags.
"
Class {
	#name : 'LDAPDecoder',
	#superclass : 'BERDecoder',
	#classVars : [
		'LdapTags'
	],
	#category : 'LDAP-Core',
	#package : 'LDAP',
	#tag : 'Core'
}

{ #category : 'class initialization' }
LDAPDecoder class >> initialize [ 
"LDAP messages class initialization. Populate the knownTags variable for application elements creation."
	| classes |
	classes := BERElement allSubclasses.
	classes := classes select: [ :c | c name beginsWith: 'LDAP' ].
	classes := classes select: [ :c | c class canPerform: #tagValue ].
	classes := classes select: [ :c | self isApplication: c tagValue  ].
	LdapTags := (classes collect: [ :c | c tagValue -> c ]) asDictionary.
]

{ #category : 'private - creation' }
LDAPDecoder >> newElementWith: aTagValue in: aParent [
"Create an element from the context"

	"If root element, create a LDAPMessage (which tag should be a BERSequence)"
	aParent ifNil: [ (aTagValue = LDAPMessage tagValue) ifTrue: [ ^ LDAPMessage new ] ].
	
	"If not application-class tag, defer to super class"
	(self class isApplication: aTagValue) ifFalse: [ ^ super newElementWith: aTagValue in: aParent ].
	
	"Then try to create an application-specific element"
	LdapTags at: aTagValue ifPresent: [ :c | ^ c new ].

	^ nil 

]
