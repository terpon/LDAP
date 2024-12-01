"
I am the state when the entry is first added to the cache. I’ll load first ths sub entries before switching to the state to load my entry attributes.
"
Class {
	#name : 'LDAPSubSearchingState',
	#superclass : 'LDAPAsyncEntryState',
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
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

	| result responses |
	"Do not call LDAPCommand>>responses in case a timeout occurred, it calls wait an will trigger another one"
	command isDone ifFalse: [ ^ LDAPNotFoundEntryState ].
	result := command responses last.
	result success ifFalse: [  
		"No result: DN does not exist, why would this entry be created"
		^ LDAPNotFoundEntryState.
	].
	responses := command responses allButLast.
	
	anEntry populateFromResults: responses.
	
	^ self onSuccessClass
]
