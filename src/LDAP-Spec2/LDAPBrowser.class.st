"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'session',
		'queue',
		'errorHandler',
		'main'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'ui - dialogs' }
LDAPBrowser class >> openConnectionDialog [
<example>

	| aLDAPBrowser |
	aLDAPBrowser := self new.
	^ aLDAPBrowser mainPresenter openConnectionDialog
]

{ #category : 'accessing' }
LDAPBrowser class >> start [
<example>
	^ self new start
]

{ #category : 'circuit setup' }
LDAPBrowser >> connect [

	session connected: false.
	queue connectWith: session server.

]

{ #category : 'running' }
LDAPBrowser >> disconnect [

	session connected: false.
	queue disconnect.

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
	
	errorHandler := LDAPDialogErrorHandler new application: self.

	queue := LDAPRequestQueue new.
	queue onErrorDo: [ :task | self errorHandler report: task result ].
	self subscribeToAnnouncements.
	
	session := LDAPSession new.
	self initializeMainPresenter 
]

{ #category : 'initialization' }
LDAPBrowser >> initializeMainPresenter [

	main := LDAPInspectorPresenter
		          newApplication: self
		          model: session.


]

{ #category : 'accessing' }
LDAPBrowser >> mainPresenter [

	^ main
]

{ #category : 'enumerating' }
LDAPBrowser >> openCustomRootDialog [

	| dialog |
	dialog := self newRequest
		title: 'Custom Naming Context';
		label: 'Enter new root DN:'.
	dialog openDialog.
	^ dialog
]

{ #category : 'accessing' }
LDAPBrowser >> queue [
	^ queue
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	errorHandler reset.

]

{ #category : 'accessing' }
LDAPBrowser >> session [

	^ session
]

{ #category : 'accessing' }
LDAPBrowser >> session: anObject [

	session := anObject
]

{ #category : 'running' }
LDAPBrowser >> start [
<script: 'self start'>

	^ main open
]

{ #category : 'initialization' }
LDAPBrowser >> subscribeToAnnouncements [

	queue when: LDAPSessionConnected do: [ self session connected: true ].
	queue when: LDAPSessionDisconnected do: [ self session connected: false ].
	queue when: LDAPNamingContextsChange do: [ :ann | self session roots: ann roots ].

]
