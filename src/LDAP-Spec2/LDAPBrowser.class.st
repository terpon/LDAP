"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'session',
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
LDAPBrowser >> connectionAccept: aSessionOrPresenter [
	| success |
	success := session copyFrom: aSessionOrPresenter.
	(success and: [ session connected ]) ifTrue: [ ^ self ].
	session connect.
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
	
	session := LDAPSession new application: self.
	errorHandler := LDAPDialogErrorHandler new application: self; yourself.
]

{ #category : 'ui - dialogs' }
LDAPBrowser >> openBrowser [

	| presenter |
	presenter := LDAPBrowserPresenter newApplication: self model: session.
	^ presenter open

]

{ #category : 'ui - dialogs' }
LDAPBrowser >> openConnectionDialog [
	
	| presenter |
	presenter := LDAPConnectionPresenter newApplication: self.
	presenter onAccept: [ :sender | self connectionAccept: sender ].
	^ presenter openDialog
	
	
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
