"
I am an end state for the cached entry. I will not be updated unless I am invalidated.
"
Class {
	#name : 'LDAPEndEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'testing' }
LDAPEndEntryState >> atEnd [
"true until invalidated"
	^ true
]

{ #category : 'changing state' }
LDAPEndEntryState >> nextFor: anEntry on: anApplication [

	^ self
]
