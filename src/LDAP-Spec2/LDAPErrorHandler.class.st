"
I am the base abstract class for reporting error.

I keep the current application if I need to show some UI.
"
Class {
	#name : 'LDAPErrorHandler',
	#superclass : 'Object',
	#instVars : [
		'application'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPErrorHandler >> application [

	^ application
]

{ #category : 'accessing' }
LDAPErrorHandler >> application: anObject [

	application := anObject
]

{ #category : 'reporting' }
LDAPErrorHandler >> report: aResult [

	self subclassResponsibility
]

{ #category : 'initialization' }
LDAPErrorHandler >> reset [
"Nothing in the base class"
]
