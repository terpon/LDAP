"
I am an abstract clipboard paste command. Subclass me if you need a DN to access.
"
Class {
	#name : 'LDAPClipboardName',
	#superclass : 'LDAPClipboardNull',
	#instVars : [
		'name'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'comparing' }
LDAPClipboardName >> = anObject [
	
	(self class = anObject class) ifFalse: [ ^ false ].
	^ self name = anObject name
]

{ #category : 'testing' }
LDAPClipboardName >> canBePastedAt: aName [

	self subclassResponsibility.
	^ false
]

{ #category : 'testing' }
LDAPClipboardName >> isValidOnInvalidateName: aName [
	
	self subclassResponsibility.
	^ false
]

{ #category : 'accessing' }
LDAPClipboardName >> name [

	^ name
]

{ #category : 'accessing' }
LDAPClipboardName >> name: anObject [

	name := anObject
]
