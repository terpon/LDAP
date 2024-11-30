"
I am the state when the entry self attributes are still valid but the sub entries need to be reloaded.
"
Class {
	#name : 'LDAPOnlySubSearchingState',
	#superclass : 'LDAPSubSearchingState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'private - changes' }
LDAPOnlySubSearchingState >> onSuccessClass [

	^ LDAPLoadedEntryState
]
