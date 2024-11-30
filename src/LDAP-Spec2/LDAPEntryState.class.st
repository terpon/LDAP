"
I am a base class for a state machine for refreshing LDAP entry state.
"
Class {
	#name : 'LDAPEntryState',
	#superclass : 'Object',
	#instVars : [
		'application',
		'entry'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'instance creation' }
LDAPEntryState class >> from: aState [
"Give full ownership of the entry to the new state"
"TODO: check if we need a mutex here, or have a method in aState with the mutex there"
	| anEntry anApplication|
	anEntry := aState entry.
	aState entry: nil.
	anApplication := aState application.
	^ self new application: anApplication; entry: anEntry; yourself
]

{ #category : 'instance creation' }
LDAPEntryState class >> on: anApplication for: anEntry [
	"New state always start invalidated"
	^ LDAPInvalidatedEntryState new application: anApplication; entry: anEntry; yourself
]

{ #category : 'accessing' }
LDAPEntryState >> application [

	^ application
]

{ #category : 'accessing' }
LDAPEntryState >> application: anObject [

	application := anObject
]

{ #category : 'testing' }
LDAPEntryState >> atEnd [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
LDAPEntryState >> entry [

	^ entry
]

{ #category : 'accessing' }
LDAPEntryState >> entry: anObject [

	entry := anObject
]

{ #category : 'changing state' }
LDAPEntryState >> invalidate [

	^ LDAPInvalidatedEntryState from: self
]

{ #category : 'changing state' }
LDAPEntryState >> next [

	^ self subclassResponsibility
]
