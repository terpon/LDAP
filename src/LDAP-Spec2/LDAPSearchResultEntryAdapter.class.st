"
I adapt the LDAPSearchResultEntry response from LDAP request to the LDAPEntryPresenter.
"
Class {
	#name : 'LDAPSearchResultEntryAdapter',
	#superclass : 'LDAPEntryAdapter',
	#instVars : [
		'entry'
	],
	#category : 'LDAP-Spec2-Utilities',
	#package : 'LDAP-Spec2',
	#tag : 'Utilities'
}

{ #category : 'adapter' }
LDAPSearchResultEntryAdapter >> attributes [

	^ entry attributes collect: [ :each | "List of BERSequence { BEROctetString. BERSet }" 
			{ each elements first value. each elements second elements collect: [ :v | v value ] }
		]
]

{ #category : 'adapter' }
LDAPSearchResultEntryAdapter >> dn [

	^ entry matchedDN
]

{ #category : 'accessing' }
LDAPSearchResultEntryAdapter >> entry [

	^ entry
]

{ #category : 'accessing' }
LDAPSearchResultEntryAdapter >> entry: anObject [

	entry := anObject
]
