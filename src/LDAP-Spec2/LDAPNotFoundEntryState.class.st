"
I am a state where the entry DN was not found in the directory.

I am a stable state but a new search request will be issued if I am invalidated.
"
Class {
	#name : 'LDAPNotFoundEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'testing' }
LDAPNotFoundEntryState >> atEnd [
"true until invalidated"
	^ true
]

{ #category : 'changing state' }
LDAPNotFoundEntryState >> nextFor: anEntry on: anApplication [

	^ self
]
