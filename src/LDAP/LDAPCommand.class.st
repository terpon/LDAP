"
LDAPCommand is an asynchronous command.

It contains a request that the LDAP server must execute.
"
Class {
	#name : 'LDAPCommand',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'message',
		'isDone',
		'abandoned',
		'doneSemaphore',
		'iterator',
		'responses',
		'newResponseSemaphore'
	],
	#category : 'LDAP-Core',
	#package : 'LDAP',
	#tag : 'Core'
}

{ #category : 'operating' }
LDAPCommand >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	abandoned ifNotNil: [ ^ abandoned ].

	abandoned := connection abandon: message.
	^ abandoned
	
]

{ #category : 'defaults' }
LDAPCommand >> defaultTimeout [
	"Answer the default timout for LDAP queries"
	^30 "seconds"
]

{ #category : 'initialization' }
LDAPCommand >> initializeWith: aConnection message: aMessage [
	connection := aConnection.
	message := aMessage.

	doneSemaphore := Semaphore new.
	responses := OrderedCollection new.
	abandoned := nil.
	isDone := false.
	
	"partial search results"
	newResponseSemaphore := Semaphore new.
	iterator := 0.
]

{ #category : 'testing' }
LDAPCommand >> isDone [
	^ isDone
]

{ #category : 'accessing' }
LDAPCommand >> message [
	^ message
]

{ #category : 'operating' }
LDAPCommand >> next [
	^ self nextTimeout: self defaultTimeout.


]

{ #category : 'operating' }
LDAPCommand >> nextTimeout: seconds [
	isDone ifFalse:[
		"As long as the request isn't done, synchronously wait for more results"
		newResponseSemaphore waitTimeoutSeconds: seconds.
		(responses size = iterator and:[isDone not]) ifTrue:[^self error: 'LDAP timeout'].
	].
	^ responses size > iterator
		ifTrue:[ responses at: (iterator := iterator + 1)]
]

{ #category : 'operating' }
LDAPCommand >> processResponse: aResponse [
	responses addLast: aResponse. 
	newResponseSemaphore signal.

	aResponse isEndMarker ifFalse: [ ^ self ].
	
	isDone := true. 
	doneSemaphore signal.

]

{ #category : 'accessing' }
LDAPCommand >> responses [ 
	self wait.
	^ responses
]

{ #category : 'error handing' }
LDAPCommand >> signalExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self responses do: #signalExceptions.
	self isDone ifFalse:[ LDAPTimeOut new command: self; signal ].

]

{ #category : 'accessing' }
LDAPCommand >> success [
	^ message operation processSuccessFor: self responses
]

{ #category : 'operating' }
LDAPCommand >> wait [
	self isDone ifTrue: [ ^ self ].
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : 'operating' }
LDAPCommand >> waitTimeoutMSecs: msecs [

	responses ifEmpty: [ doneSemaphore waitTimeoutMilliseconds: msecs ].

]

{ #category : 'operating' }
LDAPCommand >> waitTimeoutSeconds: seconds [
	self waitTimeoutMSecs: seconds * 1000.
]

{ #category : 'testing' }
LDAPCommand >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
