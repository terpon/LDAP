"
I represent an object class
"
Class {
	#name : 'LDAPObjectClass',
	#superclass : 'LDAPNamedObject',
	#instVars : [
		'must',
		'may',
		'kind',
		'superiors'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'accessing - extension' }
LDAPObjectClass >> extensions: aDictionary [
	"No extensions managed here"
	self checkSupport: #() in: aDictionary.

]

{ #category : 'accessing' }
LDAPObjectClass >> kind [

	^ kind ifNil: [ #structural ]
]

{ #category : 'accessing' }
LDAPObjectClass >> kind: anObject [

	kind := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> may [

	^ may ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> may: anObject [

	may := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> must [

	^ must ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> must: anObject [

	must := anObject
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors [

	^ superiors 	ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPObjectClass >> superiors: anObject [

	superiors := anObject
]
