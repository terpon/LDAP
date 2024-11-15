"
Search result code
"
Class {
	#name : 'LDAPSearchResultCode',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPSearchResultCode class >> tagValue [
	^ 16r65
]

{ #category : 'testing' }
LDAPSearchResultCode >> success [
	| code |
	code := self resultCode.	
	^ #( 0 32 ) includes: code
]
