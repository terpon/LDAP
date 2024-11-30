"
I am the state when the entry sub entries are still valid but the entry attributes need to be reloaded.
"
Class {
	#name : 'LDAPSelfSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
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
	"Do not call LDAPCommand>>responses in case a timeout occurred, it calls wait an will trigger another one"
	command isDone ifFalse: [ ^ LDAPNotFoundEntryState ].
	(command responses size = 1) ifTrue: [ 
		"No result: DN does not exist, why would this entry be created"
		^ LDAPNotFoundEntryState.
	].
	response := command responses first.
	
	anEntry populateFromPartialAttributeList: response attributes.	

	^ LDAPLoadedEntryState.
]
