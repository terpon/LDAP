Class {
	#name : 'LDAPAttributeElement',
	#superclass : 'Object',
	#instVars : [
		'index',
		'state',
		'description',
		'content'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'accessing' }
LDAPAttributeElement >> content [

	^ content
]

{ #category : 'accessing' }
LDAPAttributeElement >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
LDAPAttributeElement >> description [

	^ description
]

{ #category : 'accessing' }
LDAPAttributeElement >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
LDAPAttributeElement >> index [

	^ index
]

{ #category : 'accessing' }
LDAPAttributeElement >> index: anObject [

	index := anObject
]

{ #category : 'accessing' }
LDAPAttributeElement >> name [
	^ self description, '=', self content
]

{ #category : 'displaying - generic' }
LDAPAttributeElement >> printOn: aStream [

	aStream nextPutAll: self index asString;
		nextPutAll: ': ''';
		nextPutAll: self name;
		nextPutAll: ''' (';
		nextPutAll: self state asString;
		nextPutAll: ')'.
]

{ #category : 'accessing' }
LDAPAttributeElement >> state [

	^ state
]

{ #category : 'accessing' }
LDAPAttributeElement >> state: anObject [

	state := anObject
]
