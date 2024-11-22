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
		'running',
		'errorBlock'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPRequestQueue >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'error handling' }
LDAPRequestQueue >> checkAndReport: aCommand [

	| success result |
	success := aCommand success.
	result := aCommand responses last.
	success ifFalse: [ errorBlock cull: result ].
	^ success
]

{ #category : 'running' }
LDAPRequestQueue >> connectWith: aServerInfo [
	| command |
	self disconnect.
	connection := aServerInfo connection.
	connection connect.
	
	command := LDAPCommandProcessor new 
		request: aServerInfo bindRequest; 
		onSuccessDo: [ self onBind: aServerInfo ];
		onFailureDo: errorBlock.

	self nextPut: command
]

{ #category : 'running' }
LDAPRequestQueue >> disconnect [

	self announcer announce: LDAPSessionDisconnected new.
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
	errorBlock := [ :e | e traceCr ].
	running := false.

]

{ #category : 'private - dispatching' }
LDAPRequestQueue >> nextPut: aCommand [

	requests nextPut: aCommand.
	running ifFalse: [ self start ]

]

{ #category : 'callbacks' }
LDAPRequestQueue >> onBind: aSession [

	self announcer announce: LDAPSessionConnected new.
	self sendNamingContextsSearchFor: aSession.
]

{ #category : 'enumerating' }
LDAPRequestQueue >> onErrorDo: aBlock [

	errorBlock := aBlock.
]

{ #category : 'callbacks' }
LDAPRequestQueue >> onNamingContexts: aSession result: aCommand [

	| searchResult |
	searchResult := aCommand responses first asDictionary.
	searchResult at: 'namingContexts' ifPresent: [ :roots | 
		self announcer announce: (LDAPNamingContextsChange new roots: roots)
	].
]

{ #category : 'requests' }
LDAPRequestQueue >> sendNamingContextsSearchFor: aSession [

	| search command |
	search := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
		
	command := LDAPCommandProcessor new 
		request: search; 
		onSuccessDo: [ :task | self onNamingContexts: aSession result: task command ];
		onFailureDo: [ :task | aSession roots: #(). errorBlock cull: task ].

	self nextPut: command
]

{ #category : 'requests' }
LDAPRequestQueue >> sendRequest: aRequest onResultDo: aBlock [

	| command |
	command := LDAPCommandProcessor new 
		request: aRequest; 
		onSuccessDo: [ :task | aBlock cull: task command ];
		onFailureDo: [ :task | errorBlock cull: task. aBlock cull: task command ].

	self nextPut: command
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

{ #category : 'callbacks' }
LDAPRequestQueue >> when: aClass do: aFullBlockClosure [ 
	self announcer
		when: aClass
		do: aFullBlockClosure
		for: aFullBlockClosure receiver
]
