"
A worker (thread)
"
Class {
	#name : 'LDAPRequestQueue',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'connection',
		'process',
		'requests',
		'running'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPRequestQueue >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'running' }
LDAPRequestQueue >> connectWith: aServerInfo [
	| bind |
	self disconnect.
	connection := aServerInfo connection.
	bind := aServerInfo bindRequest.
	
	connection requestOnConnect: bind.
	connection connect.
	(Delay forMilliseconds: 10) wait.
	connection isConnected ifFalse: [ ^ self ]. 
	
	self announcer announce: LDAPConnectionAnnouncement new.
]

{ #category : 'running' }
LDAPRequestQueue >> disconnect [

	self announcer announce: LDAPDisconnectionAnnouncement new.
	connection ifNotNil: [ connection  disconnect ].
	self stop; flush.
]

{ #category : 'flushing' }
LDAPRequestQueue >> flush [

	requests flush.
]

{ #category : 'initialization' }
LDAPRequestQueue >> initialize [
	super initialize.
	
	requests := SharedQueue new.
	running := false.

]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> nextPut: aTask [

	requests nextPut: aTask.
	running ifFalse: [ self start ]

]

{ #category : 'executing' }
LDAPRequestQueue >> processTaskResponse: aTask [
	"Process command in a fork to avoid blocking the request queue"

	[ 
		| command result |
		command := aTask command.
		command ifNil: [ ^ self reportErrorFrom: nil ].
		command responses ifEmpty: [ ^ self reportErrorFrom: command ].
		
		result := command responses last.
		result success 
			ifTrue: [ aTask activate ]
			ifFalse: [ 
				self reportErrorFrom: command.
				aTask activateOnFailure ifTrue: [ aTask activate ]
			].
	] fork
]

{ #category : 'error handling' }
LDAPRequestQueue >> reportErrorFrom: aCommand [

	self announcer announce: (LDAPErrorAnnouncement new command: aCommand)
]

{ #category : 'requests' }
LDAPRequestQueue >> sendRequest: aRequest onResultDo: aBlock [

	| task |
	task := LDAPRequestTask new 
		request: aRequest; 
		onResponseDo: [ :command | aBlock cull: command ];
		activateOnFailure: true.

	self nextPut: task
]

{ #category : 'private - running' }
LDAPRequestQueue >> sendRequestFor: aTask [ 

	| command |
	aTask ifNil: [ running := false. ^ nil ].
	command := connection request: aTask request.
	command ifNil: [ running := false. ^ nil ].
	
	aTask command: command.
	^ aTask
]

{ #category : 'private - running' }
LDAPRequestQueue >> start [
	running := true.
	process := [
		[ running ] whileTrue: [
			| task |
			task := requests peek.
			task := self sendRequestFor: task.
			task ifNotNil: [ 
				requests next. "pop the peeked task"
				task command wait.
				self processTaskResponse: task.
			].
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

{ #category : 'callbacks' }
LDAPRequestQueue >> when: aClass do: aFullBlockClosure [ 
	self announcer
		when: aClass
		do: aFullBlockClosure
		for: aFullBlockClosure receiver
]
