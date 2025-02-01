"
I report errors during the schema building.

Base class only print to transcript
"
Class {
	#name : 'LDAPSchemaLogger',
	#superclass : 'Object',
	#category : 'LDAP-Schema-Utilities',
	#package : 'LDAP-Schema',
	#tag : 'Utilities'
}

{ #category : 'reporting' }
LDAPSchemaLogger >> duplicate: aString in: aType [ 

	(String streamContents: [ :stream | 
		stream nextPutAll: 'Duplicate ';
			nextPutAll: aType asString;
			nextPutAll: ': ';
			nextPutAll: aString asString
	]) traceCr
]

{ #category : 'reporting' }
LDAPSchemaLogger >> missingAttribute: aString for: aMember in: anObject [ 

	(String streamContents: [ :stream | 
		stream nextPutAll: 'Missing attribute named ';
			nextPutAll: aString asString;
			nextPutAll: ' for ';
			nextPutAll: aMember asString;
			nextPutAll: ' in ';			
			nextPutAll: anObject asString
	]) traceCr
]

{ #category : 'reporting' }
LDAPSchemaLogger >> missingClass: aString in: anObject [ 

	(String streamContents: [ :stream | 
		stream nextPutAll: 'Missing object class named ';
			nextPutAll: aString asString;
			nextPutAll: ' in ';			
			nextPutAll: anObject asString
	]) traceCr
]

{ #category : 'reporting' }
LDAPSchemaLogger >> missingSyntax: aString in: anObject [ 

	(String streamContents: [ :stream | 
		stream nextPutAll: 'Missing syntax OID ';
			nextPutAll: aString asString;
			nextPutAll: ' in ';			
			nextPutAll: anObject asString
	]) traceCr
]

{ #category : 'reporting' }
LDAPSchemaLogger >> report [
	"Nothing here"
]

{ #category : 'initialization' }
LDAPSchemaLogger >> reset [
	"Nothing here"
]
