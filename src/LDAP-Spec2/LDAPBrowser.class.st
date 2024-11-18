"
I am the SpApplication class for LDAP presenters.
"
Class {
	#name : 'LDAPBrowser',
	#superclass : 'SpApplication',
	#instVars : [
		'bind',
		'connection'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'connecting' }
LDAPBrowser >> connectionAccept: aPresenter [

	self reset.
	connection := aPresenter isSSL ifTrue: [ LDAPSConnection new ] ifFalse: [ LDAPConnection new ].
	connection host: aPresenter hostname; port: aPresenter port.
	
	bind username: aPresenter username; password: aPresenter password.
	
	self updateConnection
]

{ #category : 'initialization' }
LDAPBrowser >> initialize [ 

	super initialize.
	
	bind := LDAPBindRequest new.
]

{ #category : 'ui - dialogs' }
LDAPBrowser >> openConnectionDialog [
	
	| presenter |
	presenter := self newPresenter: LDAPConnectionPresenter.
	connection ifNotNil: [ presenter connection: connection ].
	presenter bindRequest: bind.
	
	^ presenter openDialog
	
	
]

{ #category : 'connecting' }
LDAPBrowser >> reset [ 

	connection ifNil: [ ^ self ].
	connection disconnect.
	connection := nil.
]

{ #category : 'connecting' }
LDAPBrowser >> updateConnection [
"Try to connect and refresh naming context"
]
