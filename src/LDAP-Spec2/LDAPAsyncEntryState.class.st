"
I am an abstract state with helper methods to deal with asynchronous requests
"
Class {
	#name : 'LDAPAsyncEntryState',
	#superclass : 'LDAPEntryState',
	#instVars : [
		'done',
		'nextClass',
		'command'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'testing' }
LDAPAsyncEntryState >> atEnd [

	^ false
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> done: aCommand [
"subclasses implementations should override the process and reture the next class on success"
	
	command := aCommand.
	done signal
	
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> fail: aCommand [ 

	command := aCommand.
	nextClass := LDAPNotFoundEntryState.
	done signal
]

{ #category : 'changing state' }
LDAPAsyncEntryState >> nextFor: anEntry on: anApplication [

	anApplication isConnected ifFalse: [ ^ self invalidate ].
	
	done ifNil: [
		done := Semaphore new.
		self runFor: anEntry on: anApplication.
	].
	done isSignaled ifFalse: [ ^ self ].
	
	nextClass := (self update: anEntry) ifNil: [ LDAPInvalidatedEntryState ].
	^ nextClass new
]

{ #category : 'running' }
LDAPAsyncEntryState >> runFor: anEntry on: anApplication [

	^ self subclassResponsibility
]

{ #category : 'private - dispatching' }
LDAPAsyncEntryState >> sendRequest: aRequest on: anApplication [

	anApplication queue sendRequest: aRequest
		onSuccessDo: [ :aCommand | self done: aCommand ]
		onFailureDo: [ :aCommand | self fail: aCommand ]
]

{ #category : 'private - updating' }
LDAPAsyncEntryState >> update: anEntry [

	self subclassResponsibility.
	^ nil
]
