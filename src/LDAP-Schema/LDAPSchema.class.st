"
I contain the schema description for LDAP entries
"
Class {
	#name : 'LDAPSchema',
	#superclass : 'Object',
	#instVars : [
		'objectClasses',
		'objectClassNames'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'adding' }
LDAPSchema >> addObjectClass: anObject [

	objectClasses add: anObject.
	objectClassNames at: anObject oid put: anObject.
	anObject names do: [ :name | objectClassNames at: name asLowercase put: anObject ].
]

{ #category : 'initialization' }
LDAPSchema >> initialize [ 
	super initialize.
	
	objectClasses := Set new.
	objectClassNames := Dictionary new.
]

{ #category : 'accessing' }
LDAPSchema >> objectClass: aString ifAbsent: aBlock [

	^ objectClassNames at: aString asLowercase ifAbsent: aBlock
]
