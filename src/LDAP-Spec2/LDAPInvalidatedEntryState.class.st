"
I am the state when the entry needs to be refreshed.
"
Class {
	#name : 'LDAPInvalidatedEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPInvalidatedEntryState >> atEnd [ 

	^ application connected not
]

{ #category : 'changing state' }
LDAPInvalidatedEntryState >> invalidate [ 

	^ self
]

{ #category : 'changing state' }
LDAPInvalidatedEntryState >> next [ 

	application connected ifFalse: [ ^ self ].

	^ LDAPSubSearchingState from: self
]
