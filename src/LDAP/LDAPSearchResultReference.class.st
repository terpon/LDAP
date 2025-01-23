"
I am a reference from a `LDAPSearchResult`.

I get returned by the server if the request asked for not dereferencing.
"
Class {
	#name : 'LDAPSearchResultReference',
	#superclass : 'LDAPSearchPartialResult',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPSearchResultReference class >> tagValue [
	^ 16r73
]

{ #category : 'testing' }
LDAPSearchResultReference >> isReference [
	^ true
]

{ #category : 'accessing' }
LDAPSearchResultReference >> url [
	^ elements first asString
]

{ #category : 'accessing' }
LDAPSearchResultReference >> urls [
	^ elements collect: #asString

]
