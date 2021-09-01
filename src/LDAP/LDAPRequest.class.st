"
LDAPRequest is an operation request that the LDAP server must execute.
"
Class {
	#name : #LDAPRequest,
	#superclass : #Object,
	#instVars : [
		'worker',
		'messageId',
		'isDone',
		'abandoned',
		'response',
		'doneSemaphore',
		'iterator',
		'partialResponses',
		'newResponse'
	],
	#category : #'LDAP-Core'
}

{ #category : #accessing }
LDAPRequest >> abandon [
	"RFC says we MUST NOT send abandon requests for the same operation multiple times"
	abandoned ifNotNil: [ ^ abandoned ].

	abandoned := LDAPRequest new initializeWith: worker request: (LDAPAbandonRequest new abandonId: messageId).
	worker delTargetFor: messageId.
	
	^ abandoned
	
]

{ #category : #'error handing' }
LDAPRequest >> checkForExceptions [
	"Check to see if a response caused an exception and if so, raise it"
	self isDone ifFalse:[^self error: 'LDAP timeout'].
	partialResponses do: #checkForExceptions.
]

{ #category : #defaults }
LDAPRequest >> defaultTimeout [
	"Answer the default timout for LDAP queries"
	^30 "seconds"
]

{ #category : #testing }
LDAPRequest >> hasResult [
	^ isDone
]

{ #category : #initialization }
LDAPRequest >> initializeWith: anLDAPWorker request: aRequest [
	worker := anLDAPWorker.
	messageId := worker nextMessageId.
	doneSemaphore := Semaphore new.
	response := nil.
	abandoned := nil.
	isDone := false.
	
	"partial search results"
	newResponse := Semaphore new.
	iterator := 0.
	partialResponses := OrderedCollection new.

	worker addTarget: self for: messageId.
	worker send: (LDAPMessage id: messageId request: aRequest) encoded.

]

{ #category : #testing }
LDAPRequest >> isDone [
	^ isDone
]

{ #category : #accessing }
LDAPRequest >> next [
	^ self nextTimeout: self defaultTimeout.


]

{ #category : #accessing }
LDAPRequest >> nextTimeout: seconds [
	isDone ifFalse:[
		"As long as the request isn't done, synchronously wait for more results"
		newResponse waitTimeoutSeconds: seconds.
		(partialResponses size = iterator and:[isDone not]) ifTrue:[^self error: 'LDAP timeout'].
	].
	^ partialResponses size > iterator
		ifTrue:[ partialResponses at: (iterator := iterator + 1)]
		ifFalse:[ nil ]
]

{ #category : #accessing }
LDAPRequest >> processResponse: aMessage [
	partialResponses addLast: aMessage. 
	aMessage isEndMarker ifTrue:[
		isDone := true. 
		response := partialResponses size > 1 ifTrue: [ partialResponses ] ifFalse: [ partialResponses first ].
		doneSemaphore signal.
	].
	newResponse signal.

]

{ #category : #accessing }
LDAPRequest >> response [
	self wait.
	^ response
]

{ #category : #accessing }
LDAPRequest >> result [
	self wait.
	^ partialResponses isEmpty ifFalse: [ partialResponses last processResult ]
]

{ #category : #accessing }
LDAPRequest >> wait [
	^self waitTimeoutSeconds: self defaultTimeout

]

{ #category : #accessing }
LDAPRequest >> waitTimeoutMSecs: msecs [
	response ifNil: [ doneSemaphore waitTimeoutMSecs: msecs ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> waitTimeoutSeconds: seconds [
	response ifNil: [ doneSemaphore waitTimeoutSeconds: seconds ].
	self checkForExceptions.
]

{ #category : #accessing }
LDAPRequest >> wantsMoreResponses [
	"you most likely not want to implement this in a subclass, but processResponse:"
	^ self isDone not
]
