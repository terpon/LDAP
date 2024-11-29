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

	^ self new application: aState application; entry: aState entry; yourself
]

{ #category : 'instance creation' }
LDAPEntryState class >> on: anApplication for: anEntry [

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
