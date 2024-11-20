"
A worker (thread)
"
Class {
	#name : 'LDAPRequestQueue',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'process',
		'lock',
		'requests',
		'commands',
		'running'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPRequestQueue >> connection: anObject [

	connection := anObject
]

{ #category : 'flushing' }
LDAPRequestQueue >> flush [

	requests flush.
]

{ #category : 'testing' }
LDAPRequestQueue >> hasResult [ 
	^ commands isEmpty not
]

{ #category : 'initialization' }
LDAPRequestQueue >> initialize [
	super initialize.
	
	lock := Semaphore forMutualExclusion.
	requests := SharedQueue new.
	commands := SharedQueue new.
	running := false.

]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> nextPut: aRequest [

	self nextPut: aRequest onResponseDo: [].

]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> nextPut: aRequest onResponseDo: aBlock [

	| processor |
	processor := LDAPCommandProcessor new request: aRequest; onResponseDo: aBlock.

	requests nextPut: processor.
	running ifFalse: [ self start ]


]

{ #category : 'accessing' }
LDAPRequestQueue >> nextResult [

	^ commands nextOrNil 
]

{ #category : 'private - running' }
LDAPRequestQueue >> start [
	running := true.
	process := [
		[ running ] whileTrue: [
			| command processor |
			processor := requests next.
			command := connection request: processor request.
			command wait.
			processor processCommand: command.
			requests isEmpty ifTrue: [ running := false ]
		].
		running := false.	
	] fork.

]

{ #category : 'private - running' }
LDAPRequestQueue >> stop [
	"The process will stop when the next request it done"
	running := false.
]
