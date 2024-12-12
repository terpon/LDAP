"
I represent an object class
"
Class {
	#name : 'LDAPAttributeType',
	#superclass : 'LDAPNamedObject',
	#instVars : [
		'superior',
		'equality',
		'ordering',
		'substr',
		'syntax',
		'syntaxLength',
		'usage',
		'ordered',
		'collective',
		'singleValue',
		'noUserModification'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'accessing' }
LDAPAttributeType >> canBeModified [

	^ self cannotBeModified not
]

{ #category : 'accessing' }
LDAPAttributeType >> cannotBeModified [

	^ noUserModification ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> collective: anObject [

	collective := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> equality [

	^ equality
]

{ #category : 'accessing' }
LDAPAttributeType >> equality: anObject [

	equality := anObject
]

{ #category : 'accessing - extension' }
LDAPAttributeType >> extensions: aDictionary [
	"No extensions managed here"
]

{ #category : 'accessing' }
LDAPAttributeType >> isCollective [

	^ collective ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> isMultipleValue [

	^ self isSingleValue not
]

{ #category : 'testing' }
LDAPAttributeType >> isOperationalAttribute [

	^ self isUserAttribute not

]

{ #category : 'accessing' }
LDAPAttributeType >> isSingleValue [

	^ singleValue ifNil: [ false ]
]

{ #category : 'testing' }
LDAPAttributeType >> isUserAttribute [

	^ usage = #userApplications

]

{ #category : 'accessing' }
LDAPAttributeType >> noUserModification: anObject [

	noUserModification := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> ordering [

	^ ordering
]

{ #category : 'accessing' }
LDAPAttributeType >> ordering: anObject [

	ordering := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> singleValue: anObject [

	singleValue := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> substring [

	^ substr
]

{ #category : 'accessing' }
LDAPAttributeType >> substring: anObject [

	substr := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> superior [

	^ superior
]

{ #category : 'accessing' }
LDAPAttributeType >> superior: anObject [

	superior := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> syntax [

	^ syntax
]

{ #category : 'accessing' }
LDAPAttributeType >> syntax: anObject [

	syntax := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> syntaxLength [

	^ syntaxLength
]

{ #category : 'accessing' }
LDAPAttributeType >> syntaxLength: anObject [

	syntaxLength := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> usage [

	^ usage
]

{ #category : 'accessing' }
LDAPAttributeType >> usage: anObject [

	usage := anObject
]
