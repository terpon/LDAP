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

	^ Array streamContents: [ :out | entry attributes do: [ :partialAttribute |
			out nextPutAll: partialAttribute flattened 
		]  ]
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
