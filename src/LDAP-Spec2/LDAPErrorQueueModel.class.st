"
I am a list of commands that triggered errors. I have a size limit and overflowind errors get thrown to the transcript.
"
Class {
	#name : 'LDAPErrorQueueModel',
	#superclass : 'Model',
	#instVars : [
		'max',
		'queue',
		'lock',
		'position'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'private - sizing' }
LDAPErrorQueueModel >> clipQueue [

	(queue size > max) ifFalse: [ ^ self ].
	
	(max + 1) to: queue size do: [ :i | self traceReport: (queue at: i)].
	queue removeLast: (queue size - max) 

]

{ #category : 'accessing' }
LDAPErrorQueueModel >> current [

	| current |
	current := #( 0 0 nil ) asOrderedCollection.
	lock critical: [
		queue ifEmpty: [ ^ current ].
		current at: 1 put: position.
		current at: 2 put: queue size.
		current at: 3 put: (queue at: position).
	].
	^ current
]

{ #category : 'accessing' }
LDAPErrorQueueModel >> currentCommand [

	^ lock critical: [
		queue ifNotEmpty: [ queue at: position ] ifEmpty: [nil].
	]
]

{ #category : 'initialization' }
LDAPErrorQueueModel >> initialize [ 

	super initialize.
	
	max := 10.
	position := 0.
	queue := OrderedCollection new.
	lock := Semaphore forMutualExclusion.

]

{ #category : 'accessing' }
LDAPErrorQueueModel >> maxSize: anInteger [

	lock critical: [
		max := anInteger.
		self clipQueue.
	]
]

{ #category : 'api - events' }
LDAPErrorQueueModel >> next [
	position < queue size ifFalse: [ ^ self ].
	position := position + 1.
	self valueChanged.
]

{ #category : 'api - events' }
LDAPErrorQueueModel >> previous [
	position <= 1 ifTrue: [ ^ self ].
	position := position - 1.
	self valueChanged.
]

{ #category : 'removing' }
LDAPErrorQueueModel >> removeAll [
	
	lock critical: [
		queue ifEmpty: [ ^ self ].
		queue removeAll.
		position := 0.
	].
	self valueChanged
]

{ #category : 'removing' }
LDAPErrorQueueModel >> removeCurrent [

	| element |
	element := nil.
	lock critical: [
		queue ifEmpty: [ ^ element ].
		element := queue removeAt: position.
		position := position min: queue size.
	].
	self valueChanged.
	^ element
]

{ #category : 'reporting' }
LDAPErrorQueueModel >> report: aLDAPResult [

	lock critical: [
		(queue size >= max) ifTrue: [ ^ self traceReport: aLDAPResult ].
		queue addLast: aLDAPResult.
		(position = 0) ifTrue: [ position := 1 ].
	].
	self valueChanged


]

{ #category : 'reporting' }
LDAPErrorQueueModel >> traceReport: aCommand [
	
	| aMessage |
	aMessage := aCommand ifNil: [ 'a nil LDAPCommand' ]
		ifNotNil: [
			aCommand responses ifEmpty: [ 'a LDAPCommand with no reponses' ]
				ifNotEmpty: [ :r | r last resultElement printString ]
		].
	(String streamContents: [ :s |
		s nextPutAll: 'LDAP error overflow: ';
		nextPutAll: aMessage
	]) traceCr.

]
