Class {
	#name : 'LDAPAsyncTask',
	#superclass : 'Object',
	#instVars : [
		'successBlock',
		'failureBlock'
	],
	#category : 'LDAP-Spec2-Connection',
	#package : 'LDAP-Spec2',
	#tag : 'Connection'
}

{ #category : 'events' }
LDAPAsyncTask >> failure [

	^ failureBlock ifNotNil: [ failureBlock cull: self ]
]

{ #category : 'enumerating' }
LDAPAsyncTask >> onFailureDo: aBlock [

	failureBlock := aBlock 
]

{ #category : 'accessing' }
LDAPAsyncTask >> onSuccessDo: aBlock [

	successBlock := aBlock 
]

{ #category : 'events' }
LDAPAsyncTask >> success [

	^ successBlock ifNotNil: [ successBlock cull: self ]
]
