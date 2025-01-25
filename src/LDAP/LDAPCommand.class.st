"
LDAPCommand is an asynchronous command.

It contains a request that the LDAP server must execute.
"
Class {
	#name : 'LDAPCommand',
	#superclass : 'Object',
	#instVars : [
		'message',
		'isDone',
		'doneSemaphore',
		'iterator',
		'responses',
		'newResponseSemaphore'
	],
	#category : 'LDAP-Elements',
	#package : 'LDAP',
	#tag : 'Elements'
}

{ #category : 'defaults' }
LDAPCommand >> defaultTimeout [
	"Answer the default timout for LDAP queries"
	^30 "seconds"
]

{ #category : 'initialization' }
LDAPCommand >> initializeWith: aMessage [

	message := aMessage.

	doneSemaphore := Semaphore new.
	responses := OrderedCollection new.
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
		(responses size = iterator and:[isDone not]) ifTrue:[ LDAPTimeOut new command: self; signal. ^ nil ].
	].
	^ responses size > iterator
		ifTrue:[ responses at: (iterator := iterator + 1)]
]

{ #category : 'private - operating' }
LDAPCommand >> processResponse: aResponse [
	"return true if command can be retired"
	responses addLast: aResponse. 
	newResponseSemaphore signal.

	isDone := aResponse isEndMarker.
	isDone ifTrue: [ doneSemaphore signal ].
	
	^ isDone
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

]

{ #category : 'accessing' }
LDAPCommand >> success [

	self isDone ifFalse: [ ^false ].

	^ responses allSatisfy: #success
]

{ #category : 'operating' }
LDAPCommand >> wait [
	self isDone ifTrue: [ ^ self ].
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : 'operating' }
LDAPCommand >> waitTimeoutMSecs: msecs [

	responses ifEmpty: [ doneSemaphore waitTimeoutMilliseconds: msecs ].
	isDone ifFalse: [ LDAPTimeOut new command: self; signal ].

]

{ #category : 'operating' }
LDAPCommand >> waitTimeoutSeconds: seconds [
	self waitTimeoutMSecs: seconds * 1000.
]
