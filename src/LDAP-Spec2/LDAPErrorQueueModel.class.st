Class {
	#name : 'LDAPErrorQueueModel',
	#superclass : 'Model',
	#instVars : [
		'max',
		'queue',
		'lock',
		'current'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'private - sizing' }
LDAPErrorQueueModel >> clipQueue [

	(queue size > max) ifTrue: [ queue removeLast: (queue size - max) ]
]

{ #category : 'api - events' }
LDAPErrorQueueModel >> current [ 

	^ current
]

{ #category : 'removing' }
LDAPErrorQueueModel >> currentResult [

	| element |
	element := nil.
	lock critical: [
		queue ifEmpty: [ ^ element ].
		element := queue at: current.
	].
	^ element
]

{ #category : 'initialization' }
LDAPErrorQueueModel >> initialize [ 

	super initialize.
	
	max := 10.
	current := 0.
	queue := OrderedCollection new.
	lock := Semaphore forMutualExclusion.

]

{ #category : 'api - events' }
LDAPErrorQueueModel >> next [
	current < queue size ifFalse: [ ^ self ].
	current := current + 1.
	self valueChanged.
]

{ #category : 'api - events' }
LDAPErrorQueueModel >> previous [
	current <= 1 ifTrue: [ ^ self ].
	current := current - 1.
	self valueChanged.
]

{ #category : 'accessing' }
LDAPErrorQueueModel >> queueSize: anInteger [

	lock critical: [
		max := anInteger.
		self clipQueue.
	]
]

{ #category : 'removing' }
LDAPErrorQueueModel >> removeAll [
	
	lock critical: [
		queue ifEmpty: [ ^ self ].
		queue removeAll.
		current := 0.
	].
	self valueChanged
]

{ #category : 'removing' }
LDAPErrorQueueModel >> removeCurrent [

	| element |
	element := nil.
	lock critical: [
		queue ifEmpty: [ ^ element ].
		element := queue removeAt: current.
		current := current min: queue size.
	].
	self valueChanged.
	^ element
]

{ #category : 'reporting' }
LDAPErrorQueueModel >> report: aLDAPResult [

	lock critical: [
		(queue size >= max) ifTrue: [ ^ self traceReport: aLDAPResult ].
		queue addLast: aLDAPResult.
		(current = 0) ifTrue: [ current := 1 ].
	].
	self valueChanged


]

{ #category : 'accessing' }
LDAPErrorQueueModel >> size [

	^ queue size
]

{ #category : 'reporting' }
LDAPErrorQueueModel >> traceReport: aLDAPResult [

	(String streamContents: [ :s |
		s nextPutAll: 'LDAP error overflow: ';
		nextPutAll: aLDAPResult resultElement printString
	]) traceCr.

]
