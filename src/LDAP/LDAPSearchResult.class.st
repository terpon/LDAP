"
Search result code
"
Class {
	#name : 'LDAPSearchResult',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPSearchResult class >> tagValue [
	^ 16r65
]

{ #category : 'testing' }
LDAPSearchResult >> found [
	"32 (noSuchObject) means the only failure is to find the DN"
	^ self resultCode = 0
]

{ #category : 'testing' }
LDAPSearchResult >> success [
	| code |
	code := self resultCode.	
	^ #( 0 32 ) includes: code
]
