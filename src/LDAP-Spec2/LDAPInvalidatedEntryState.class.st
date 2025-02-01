"
I am the state when the entry needs to be refreshed.
"
Class {
	#name : 'LDAPInvalidatedEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'testing' }
LDAPInvalidatedEntryState >> atEnd [ 

	^ false
]

{ #category : 'changing state' }
LDAPInvalidatedEntryState >> invalidate [ 

	^ self
]

{ #category : 'changing state' }
LDAPInvalidatedEntryState >> nextFor: anEntry on: anApplication [

	^ LDAPSubSearchingState new
]
