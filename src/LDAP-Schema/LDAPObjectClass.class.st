"
I represent an object class
"
Class {
	#name : 'LDAPObjectClass',
	#superclass : 'Object',
	#instVars : [
		'oid',
		'names',
		'description',
		'obsolete',
		'superiors',
		'must',
		'may'
	],
	#category : 'LDAP-Schema',
	#package : 'LDAP-Schema'
}

{ #category : 'testing' }
LDAPObjectClass class >> isAbstract [

	^ self = LDAPObjectClass 
]

{ #category : 'description' }
LDAPObjectClass class >> kind [

	self subclassResponsibility.
	^ #none
]

{ #category : 'instance creation' }
LDAPObjectClass class >> kindClass: aString [

	| aSymbol |
	aSymbol := aString asSymbol.
	^ self subclasses detect: [ :c | c kind = aSymbol ]
]

{ #category : 'instance creation' }
LDAPObjectClass class >> newKind: aString [

	^ (self kindClass: aString) new
]

{ #category : 'comparing' }
LDAPObjectClass >> = anObject [

	^ oid = anObject oid
]

{ #category : 'comparing' }
LDAPObjectClass >> hash [

	^ oid hash
]

{ #category : 'accessing' }
LDAPObjectClass >> oid [

	^ oid
]
