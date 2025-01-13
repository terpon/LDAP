"
I am a base class for a state machine for refreshing LDAP entry state.
"
Class {
	#name : 'LDAPEntryState',
	#superclass : 'Object',
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'testing' }
LDAPEntryState >> atEnd [

	^ self subclassResponsibility
]

{ #category : 'changing state' }
LDAPEntryState >> invalidate [

	^ LDAPInvalidatedEntryState new
]

{ #category : 'changing state' }
LDAPEntryState >> nextFor: anEntry on: anApplication [

	^ self subclassResponsibility
]
