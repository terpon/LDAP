Class {
	#name : 'LDAPLoadedEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPLoadedEntryState >> atEnd [
"true until invalidated"
	^ true
]

{ #category : 'changing state' }
LDAPLoadedEntryState >> next [

	^ self
]
