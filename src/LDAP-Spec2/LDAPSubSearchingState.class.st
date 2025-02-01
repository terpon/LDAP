"
I am the state when the entry is first added to the cache. I’ll load first ths sub entries before switching to the state to load my entry attributes.
"
Class {
	#name : 'LDAPSubSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'private - changes' }
LDAPSubSearchingState >> onSuccessClass [

	^ LDAPSelfSearchingState
]

{ #category : 'running' }
LDAPSubSearchingState >> runFor: anEntry on: anApplication [
"Search will return the child nodes of aDN"
	| aRequest aDN |
	aDN := anEntry name.
	aRequest := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPSingleLevelScope new.

	self sendRequest: aRequest on: anApplication
]

{ #category : 'private - updating' }
LDAPSubSearchingState >> update: anEntry [

	| responses |
	responses := command responses allButLast.
	
	anEntry populateFromResults: responses.
	
	^ self onSuccessClass
]
