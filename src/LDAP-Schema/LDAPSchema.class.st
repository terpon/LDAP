"
I contain the schema description for LDAP entries
"
Class {
	#name : 'LDAPSchema',
	#superclass : 'Object',
	#instVars : [
		'objects',
		'objectClasses',
		'attributeSyntaxes',
		'attributeTypes'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'adding' }
LDAPSchema >> addObjectClass: anObject [

	objects add: anObject.
	objectClasses at: anObject oid put: anObject.
	anObject names do: [ :name | objectClasses at: name asLowercase put: anObject ].
]

{ #category : 'adding' }
LDAPSchema >> addSyntax: anObject [

	objects add: anObject.
	attributeSyntaxes at: anObject oid put: anObject.
]

{ #category : 'adding' }
LDAPSchema >> addType: anObject [

	objects add: anObject.
	attributeTypes at: anObject oid put: anObject.
	anObject names do: [ :name | attributeTypes at: name asLowercase put: anObject ].
]

{ #category : 'initialization' }
LDAPSchema >> initialize [ 
	super initialize.
	
	objects := Set new.
	objectClasses := Dictionary new.
	attributeSyntaxes := Dictionary new.
	attributeTypes := Dictionary new.
]

{ #category : 'accessing' }
LDAPSchema >> objectClass: aString ifAbsent: aBlock [

	^ objectClasses at: aString asLowercase ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> syntax: aString ifAbsent: aBlock [

	^ attributeSyntaxes at: aString ifAbsent: aBlock
]

{ #category : 'accessing' }
LDAPSchema >> type: aString ifAbsent: aBlock [

	^ attributeTypes at: aString asLowercase ifAbsent: aBlock
]
