"
I am the state when the entry sub entries are still valid but the entry attributes need to be reloaded.
"
Class {
	#name : 'LDAPSelfSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'private - changes' }
LDAPSelfSearchingState >> process: aCommand [

	| response |
	(aCommand responses size = 1) ifTrue: [ 
		"No result: DN does not exist, why would this entry be created"
		^ LDAPNotFoundEntryState.
	].
	response := aCommand responses first.
	
	entry populateFromPartialAttributeList: response attributes.	

	^ LDAPLoadedEntryState.
]

{ #category : 'running' }
LDAPSelfSearchingState >> run [
"Search will return the base node for aDN"
	| aRequest aDN |
	aDN := entry name.
	aRequest := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPBaseObjectScope new.

	self sendRequest: aRequest
]
