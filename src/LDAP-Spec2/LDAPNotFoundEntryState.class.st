Class {
	#name : 'LDAPNotFoundEntryState',
	#superclass : 'LDAPEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPNotFoundEntryState >> atEnd [
"true until invalidated"
	^ true
]

{ #category : 'changing state' }
LDAPNotFoundEntryState >> next [

	^ self
]
