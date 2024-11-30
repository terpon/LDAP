"
I am the state where the entry is fully loaded.

"
Class {
	#name : 'LDAPLoadedEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'testing' }
LDAPLoadedEntryState >> atEnd [
"true until invalidated"
	^ true
]

{ #category : 'changing state' }
LDAPLoadedEntryState >> nextFor: anEntry on: anApplication [

	^ self
]
