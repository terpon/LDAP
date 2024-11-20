"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'queue',
		'connection',
		'errorHandler'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'error handling' }
LDAPBrowser >> checkAndReport: aCommand [

	| success result |
	success := aCommand success.
	result := aCommand responses last.
	success ifFalse: [ errorHandler report: result ].
	^ success
]

{ #category : 'connecting' }
LDAPBrowser >> connectionAccept: aModel [

	self reset.
	connection := aModel.
	self updateConnection
]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler [

	^ errorHandler
]

{ #category : 'accessing' }
LDAPBrowser >> errorHandler: anObject [

	errorHandler := anObject
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	queue := LDAPRequestQueue new.
	connection := LDAPConnectionModel new.
	errorHandler := LDAPDialogErrorHandler new application: self; yourself.
]

{ #category : 'callbacks' }
LDAPBrowser >> onConnect: aCommand [
	| connected |
	connected := self checkAndReport: aCommand.
	connection connected: connected.
	connected ifFalse: [ ^ self ].

	self sendNamingContextsSearch.
]

{ #category : 'callbacks' }
LDAPBrowser >> onNamingContexts: aCommand [
	| success presenter searchResult |
	success := self checkAndReport: aCommand.
	success ifFalse: [ ^ self ].

	searchResult := aCommand responses first.
	presenter := LDAPEntryPresenter newApplication: self model: searchResult.
	presenter open

]

{ #category : 'ui - dialogs' }
LDAPBrowser >> openConnectionDialog [
	
	| presenter model |
	"Make a copy so variable is not modified until dialog is accepted"
	model := connection copy.
	presenter := LDAPConnectionPresenter newApplication: self model: model.
	^ presenter openDialog
	
	
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	connection server disconnect.
	queue stop; flush.
	errorHandler reset.

]

{ #category : 'requests' }
LDAPBrowser >> sendNamingContextsSearch [

	| search |
	search := LDAPSearchRequest new
		          base: '';
		          scope: LDAPBaseObjectScope new;
		          attributes: { 'namingContexts' }.
	queue nextPut: search onResponseDo: [ :command | self onNamingContexts: command ]
]

{ #category : 'connecting' }
LDAPBrowser >> updateConnection [
"Try to connect and refresh naming context"
	| request |
	connection reconnect.
	queue connection: connection server.
	
	request := connection bindRequest.
	queue nextPut: request onResponseDo: [ :command | self onConnect: command ]
]
