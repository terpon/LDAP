Class {
	#name : 'LDAPSubSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'callbacks' }
LDAPSubSearchingState >> done: aCommand [

	| result responses |
	result := aCommand responses last.
	result found ifFalse: [  
		"No result: DN does not exist, why would this entry be created"
		nextClass := LDAPNotFoundEntryState.
		^ super done: aCommand
	].
	responses := aCommand responses allButLast.
	entry populateFromResults: responses.
	
	nextClass := LDAPSelfSearchingState.
	super done: aCommand
]

{ #category : 'running' }
LDAPSubSearchingState >> run [
"Search will return the child nodes of aDN"
	| aRequest aDN |
	aDN := entry name.
	aRequest := LDAPSearchRequest new
		          base: aDN;
		          scope: LDAPSingleLevelScope new.

	self sendRequest: aRequest
]
