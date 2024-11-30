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
"subclasses implementations should override the process and reture the next class on sucess"

	"We lost ownership during the request"
	entry ifNil: [ ^ self ].
	
	nextClass := (self process: aCommand) ifNil: [ LDAPInvalidatedEntryState ].
	
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

	entry ifNil: [ self error: 'next cannot be called with nil entry'. ^ LDAPInvalidatedEntryState from: self ].

	application connected ifFalse: [ ^ self invalidate ].
	
	done ifNil: [
		done := false.
		self run.
	].

	self isDone ifFalse: [ ^ self ].

	nextClass ifNil: [ self error: 'subclass should have set a next class'. nextClass := LDAPInvalidatedEntryState ].

	^ nextClass from: self
]

{ #category : 'private - changes' }
LDAPAsyncEntryState >> process: aCommand [

	self subclassResponsibility.
	^ false
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
