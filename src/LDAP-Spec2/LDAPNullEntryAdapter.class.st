Class {
	#name : 'LDAPNullEntryAdapter',
	#superclass : 'LDAPEntryAdapter',
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'adapter' }
LDAPNullEntryAdapter >> attributes [ 

	^ #()
]

{ #category : 'adapter' }
LDAPNullEntryAdapter >> dn [

	^ ''
]
