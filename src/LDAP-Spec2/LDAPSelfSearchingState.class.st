"
I am the state when the entry sub entries are still valid but the entry attributes need to be reloaded.
"
Class {
	#name : 'LDAPSelfSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'running' }
LDAPSelfSearchingState >> runFor: anEntry on: anApplication [
"Search will return the base node for aDN"
	| aRequest aDN |
	aDN := anEntry name.
	aRequest := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPBaseObjectScope new.

	self sendRequest: aRequest on: anApplication
]

{ #category : 'private - updating' }
LDAPSelfSearchingState >> update: anEntry [

	| response |
	response := command responses first.

	anEntry populateFromPartialAttributeList: response attributes.	

	^ LDAPLoadedEntryState.
]
