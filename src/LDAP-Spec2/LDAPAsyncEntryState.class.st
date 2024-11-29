"
I am an abstract state with helper methods to deal with asynchronous requests
"
Class {
	#name : 'LDAPAsyncEntryState',
	#superclass : 'LDAPEntryState',
	#instVars : [
		'done',
		'nextClass'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'testing' }
LDAPAsyncEntryState >> atEnd [

	^ false
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> done: aCommand [
"super done should be called at the end of subclasses implementations"
	done := true.
	
]

{ #category : 'callbacks' }
LDAPAsyncEntryState >> fail: aCommand with: anError [

	application reportException: anError.
	application reportError: aCommand.
	nextClass := LDAPNotFoundEntryState.
	done := true
]

{ #category : 'testing' }
LDAPAsyncEntryState >> isDone [

	^ done
]

{ #category : 'changing state' }
LDAPAsyncEntryState >> next [

	application connected ifFalse: [ ^ self invalidate ].
	
	done ifNil: [
		done := false.
		self run.
	].

	self isDone ifFalse: [ ^ self ].

	nextClass ifNil: [ self error: 'subclass should have set a next class'. nextClass := LDAPInvalidatedEntryState ].

	^ nextClass from: self
]

{ #category : 'running' }
LDAPAsyncEntryState >> run [

	^ self subclassResponsibility
]

{ #category : 'running' }
LDAPAsyncEntryState >> sendRequest: aRequest [

	application queue sendRequest: aRequest
		onSuccessDo: [ :command | self done: command ]
		onFailureDo: [ :command :error | self fail: command with: error ]
]
