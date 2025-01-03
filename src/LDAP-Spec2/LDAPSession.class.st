"
I represent the information to connect to a LDAP server.
"
Class {
	#name : 'LDAPSession',
	#superclass : 'Model',
	#instVars : [
		'server',
		'connected',
		'currentRoot',
		'directorySpecificEntry'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPSession >> connected [

	^ connected
]

{ #category : 'accessing' }
LDAPSession >> connected: aBoolean [

	connected = aBoolean ifTrue: [ ^ self ].
	
	connected := aBoolean.
	self valueChanged 
]

{ #category : 'instance creation' }
LDAPSession >> connectionClass [ 

	^  self isSSL ifTrue: [ LDAPSConnection ]  ifFalse: [ LDAPConnection ]
]

{ #category : 'accessing' }
LDAPSession >> currentRoot [

	^ currentRoot
]

{ #category : 'accessing' }
LDAPSession >> currentRoot: anObject [

	currentRoot = anObject ifTrue: [ ^ self ].

	currentRoot := anObject.
	self valueChanged 
]

{ #category : 'accessing' }
LDAPSession >> directorySpecificEntry: anObject [

	directorySpecificEntry = anObject ifTrue: [ ^ self ].

	directorySpecificEntry := anObject.
	self valueChanged 
]

{ #category : 'initialization' }
LDAPSession >> initialize [ 

	super initialize.
	server := LDAPServerInfo new.
	self reset
]

{ #category : 'initialization' }
LDAPSession >> reset [
"Initialize"
	connected := false.
	currentRoot := ''.
	self resetDSE.

]

{ #category : 'initialization' }
LDAPSession >> resetDSE [
"Initialize"
	directorySpecificEntry := Dictionary new.
]

{ #category : 'accessing' }
LDAPSession >> roots [
	^ directorySpecificEntry at: 'namingcontexts' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
LDAPSession >> server [

	^ server
]

{ #category : 'accessing' }
LDAPSession >> server: anObject [

	server := anObject copy.
	self valueChanged
]

{ #category : 'accessing' }
LDAPSession >> subSchema [ 
	^ directorySpecificEntry at: 'subschemasubentry' ifPresent: [ :c | c first ] ifAbsent: [ nil ]
]
