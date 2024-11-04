"
Search result code
"
Class {
	#name : 'LDAPSearchResultCode',
	#superclass : 'LDAPResult',
	#category : 'LDAP-Results',
	#package : 'LDAP',
	#tag : 'Results'
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
