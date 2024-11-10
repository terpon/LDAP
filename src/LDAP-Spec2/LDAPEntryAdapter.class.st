Class {
	#name : 'LDAPEntryAdapter',
	#superclass : 'Object',
	#category : 'LDAP-Spec2-Utilities',
	#package : 'LDAP-Spec2',
	#tag : 'Utilities'
}

{ #category : 'adapter' }
LDAPEntryAdapter >> attributes [
	^ self subclassResponsibility 
]

{ #category : 'adapter' }
LDAPEntryAdapter >> dn [
	^ self subclassResponsibility 
]
