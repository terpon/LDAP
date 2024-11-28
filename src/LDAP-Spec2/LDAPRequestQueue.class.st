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

{ #category : 'executing' }
LDAPRequestQueue >> activateResponse: aTask [
	"Process command in a fork to avoid blocking the request queue"

	[ aTask activate ] fork
]

{ #category : 'announcer' }
LDAPRequestQueue >> announceDisconnected [

	self announcer announce: LDAPDisconnectionAnnouncement new.

]

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

	self announceDisconnected.
	connection ifNotNil: [ connection disconnect ].
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

{ #category : 'error handling' }
LDAPRequestQueue >> reportErrorFrom: aCommand [

	self announcer announce: (LDAPErrorAnnouncement new command: aCommand)
]

{ #category : 'requests' }
LDAPRequestQueue >> sendRequest: aRequest onSuccessDo: aBlock onFailureDo: aFailBlock [

	| task |
	task := LDAPRequestTask new 
		request: aRequest; 
		onSuccessDo: aBlock;
		onFailureDo: aFailBlock.

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
		[ [ running ] whileTrue: [
			| aTask aCommand |
			aTask := requests peek.
			[ 
				aCommand := connection request: aTask request.
				aTask waitFor: aCommand.
				requests next. "pop the peeked task"
			] on: Exception do: [ 
				connection isConnected ifFalse: [ self announceDisconnected ].
				running := false 
			].
			self activateResponse: aTask.
			requests isEmpty ifTrue: [ running := false ]
		] ] ensure: [ 	running := false ]
	] fork.

]

{ #category : 'private - running' }
LDAPRequestQueue >> stop [
	"The process will stop when the next request it done"
	running := false.
]

{ #category : 'announcer' }
LDAPRequestQueue >> when: aClass do: aFullBlockClosure [ 
	self announcer
		when: aClass
		do: aFullBlockClosure
		for: aFullBlockClosure receiver
]

{ #category : 'announcer' }
LDAPRequestQueue >> when: anAnnouncementClass send: aSelector to: anObject [
	^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]
