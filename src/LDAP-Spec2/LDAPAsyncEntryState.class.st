"
I am an abstract state with helper methods to deal with asynchronous requests
"
Class {
	#name : 'LDAPAsyncEntryState',
	#superclass : 'LDAPEntryState',
	#instVars : [
		'nextClass',
		'command'
	],
	#category : 'LDAP-Spec2-Cache',
	#package : 'LDAP-Spec2',
	#tag : 'Cache'
}

{ #category : 'testing' }
LDAPAsyncEntryState >> atEnd [

	^ false
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> done: aCommand [
	
	command := aCommand.
	nextClass := nil.
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> fail: aCommand [ 

	command := aCommand.

	nextClass := LDAPInvalidatedEntryState.
	(command isNotNil and: [ command isDone ]) ifTrue: [
		nextClass := LDAPNotFoundEntryState.
	].
]

{ #category : 'changing state' }
LDAPAsyncEntryState >> nextFor: anEntry on: anApplication [

	self runFor: anEntry on: anApplication.
	
	"nextClass is set on failure, update is not called"
	nextClass ifNil: [
		nextClass := (self update: anEntry) ifNil: [ LDAPInvalidatedEntryState ]
	] ifNotNil: [
		"report error"
		anApplication reportError: command.
	].
	^ nextClass new
]

{ #category : 'running' }
LDAPAsyncEntryState >> runFor: anEntry on: anApplication [

	^ self subclassResponsibility
]

{ #category : 'private - dispatching' }
LDAPAsyncEntryState >> sendRequest: aRequest on: anApplication [

	anApplication sendAndWaitFor: aRequest
		onSuccessDo: [ :aCommand | self done: aCommand ]
		onFailureDo: [ :aCommand | self fail: aCommand ]
]

{ #category : 'private - updating' }
LDAPAsyncEntryState >> update: anEntry [

	self subclassResponsibility.
	^ nil
]
