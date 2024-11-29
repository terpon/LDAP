Class {
	#name : 'LDAPSelfSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'callbacks' }
LDAPSelfSearchingState >> done: aCommand [

	| response |
	(aCommand responses size = 1) ifTrue: [ 
		"No result: DN does not exist, why would this entry be created"
		nextClass := LDAPNotFoundEntryState.
		^ super done: aCommand
	].
	response := aCommand responses first.
	
	entry populateFromPartialAttributeList: response attributes.	

	nextClass := LDAPLoadedEntryState.
	super done: aCommand
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
