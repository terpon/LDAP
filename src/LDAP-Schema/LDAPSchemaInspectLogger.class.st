"
I report error in an inspector window
"
Class {
	#name : 'LDAPSchemaInspectLogger',
	#superclass : 'LDAPSchemaLogger',
	#instVars : [
		'logs'
	],
	#category : 'LDAP-Schema-Utilities',
	#package : 'LDAP-Schema',
	#tag : 'Utilities'
}

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingAttribute: aString for: aMember in: anObject [ 

	logs addLast: { 'Missing attribute'. aString . anObject . aMember }.
]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingClass: aString for: aMember in: anObject [ 

	logs addLast: { 'Missing objectClass'. aString . anObject . aMember }.
]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> missingSyntax: aString in: anObject [ 

	logs addLast: { 'Missing syntax'. aString . anObject }.
]

{ #category : 'reporting' }
LDAPSchemaInspectLogger >> report [

	logs ifNotNil: [ logs inspect ].
]

{ #category : 'initialization' }
LDAPSchemaInspectLogger >> reset [

	logs := OrderedCollection new.
]
