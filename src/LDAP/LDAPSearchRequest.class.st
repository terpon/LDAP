"
I am a request to search entries from the directory.
"
Class {
	#name : 'LDAPSearchRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPSearchRequest class >> tagValue [
	^ 16r63 "Application 3"
]

{ #category : 'accessing' }
LDAPSearchRequest >> attributes: someAttrs [
	| ber |
	ber := BERSequence new.
	someAttrs do: [ :each | ber addElement: (LDAPString new content: each) ].
	elements at: 8 put: ber.
]

{ #category : 'accessing' }
LDAPSearchRequest >> base: aDn [
"baseObject DN. For consistency, same as name"
	self name: aDn
]

{ #category : 'controlling' }
LDAPSearchRequest >> beTypesAndValues [
	self wantTypesOnly: false
]

{ #category : 'controlling' }
LDAPSearchRequest >> beTypesOnly [
	self wantTypesOnly: true
]

{ #category : 'accessing' }
LDAPSearchRequest >> derefAliases: anAliasingPolicy [
	elements at: 3 put: anAliasingPolicy
]

{ #category : 'accessing' }
LDAPSearchRequest >> filter: aFilter [
	elements at: 7 put: aFilter 
]

{ #category : 'initialization' }
LDAPSearchRequest >> initialize [ 
	super initialize.
	
	self
		addElement: (LDAPString new); "dn"
		addElement: (LDAPBaseObjectScope new); "scope"
		addElement: (LDAPNeverDeferAliases new); "derefAliases"
		addElement: (BERInteger new content: 0); "sizelimit"
		addElement: (BERInteger new content: 0); "timelimit"
		addElement: (BERBoolean new); "typesOnly"
		addElement: (LDAPFilterAnd new); "filter. Absolute true filter (&)"
		addElement: (BERSequence new). "attrs"

]

{ #category : 'accessing' }
LDAPSearchRequest >> name [
	^ elements first asString
]

{ #category : 'accessing' }
LDAPSearchRequest >> name: aDn [
	elements first content: aDn
]

{ #category : 'accessing' }
LDAPSearchRequest >> scope: aScope [
	elements at: 2 put: aScope
]

{ #category : 'accessing' }
LDAPSearchRequest >> sizeLimit: anInteger [
	elements fourth content: anInteger
]

{ #category : 'accessing' }
LDAPSearchRequest >> timeLimit: anInteger [
	elements fifth content: anInteger
]

{ #category : 'accessing' }
LDAPSearchRequest >> wantTypesOnly: aBoolean [
	elements sixth content: aBoolean
]
