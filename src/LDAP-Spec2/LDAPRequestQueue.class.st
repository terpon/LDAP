"
A worker (thread)
"
Class {
	#name : 'LDAPRequestQueue',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'connection',
		'requests'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

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
	self flush.
]

{ #category : 'flushing' }
LDAPRequestQueue >> flush [

	requests flush.
]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> flushFinishedTasks [

	requests flushAllSuchThat: [ :queued | queued isTerminated ]
]

{ #category : 'initialization' }
LDAPRequestQueue >> initialize [
	super initialize.
	
	requests := SharedQueue new.

]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> launch: aTask [

	^ [ self start: aTask ] forkAt: Processor userBackgroundPriority named: 'LDAP task for ', aTask request className

]

{ #category : 'error handling' }
LDAPRequestQueue >> reportErrorFrom: aCommand [

	self announcer announce: (LDAPErrorAnnouncement new command: aCommand)
]

{ #category : 'requests' }
LDAPRequestQueue >> sendRequest: aRequest onSuccessDo: aBlock onFailureDo: aFailBlock [

	| task |
	self flushFinishedTasks.
	
	task := LDAPRequestTask new 
		request: aRequest; 
		onSuccessDo: aBlock;
		onFailureDo: aFailBlock.

	requests nextPut: (self launch: task).
]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> start: aTask [
"This is run in a forked process"
	| aCommand |
	aCommand := [ connection request: aTask request ] on: Exception do: [ :ex | ex pass. nil ].
	aCommand ifNil: [ ^ nil ].
	aTask waitFor: aCommand.
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
