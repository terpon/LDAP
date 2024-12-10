"
I add edition commands to the LDAP browser.
"
Class {
	#name : 'LDAPEditor',
	#superclass : 'LDAPBrowser',
	#instVars : [
		'lastAddedAttributes',
		'clipboard'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'instance creation' }
LDAPEditor class >> mainPresenterClass [

	^ LDAPEditorPresenter
]

{ #category : 'searching' }
LDAPEditor >> invalidateName: aDN [
"Gets entry from the cache and invalidate it"
	| aCachedEntry |
	aCachedEntry := cache at: aDN.
	aCachedEntry invalidate.
	self isConnected ifTrue: [ aCachedEntry update: self ].
]

{ #category : 'searching' }
LDAPEditor >> invalidateParent: aDN [
"Gets entry from the cache and invalidate it"
	| parentDN |
	parentDN := LDAPName parentOf: aDN.
	self invalidateName: parentDN
]

{ #category : 'accessing' }
LDAPEditor >> lastAddedAttributes [

	^ lastAddedAttributes ifNil: [ 
			lastAddedAttributes := { LDAPLeafEntryAttribute new description: 'objectClass' } 
		]
]

{ #category : 'callbacks' }
LDAPEditor >> onAddedEntry: aDN [

	self invalidateParent: aDN.
	self inform: 'Success on adding ', aDN
]

{ #category : 'callbacks' }
LDAPEditor >> onDeletedEntry: aDN [

	self invalidateParent: aDN.
	self inform: 'Success on deleting ', aDN.

	main invalidatePage: aDN.
]

{ #category : 'callbacks' }
LDAPEditor >> onModifiedEntry: aDN [

	self invalidateName: aDN.
	self inform: 'Success on modyfying attributes in ', aDN
]

{ #category : 'callbacks' }
LDAPEditor >> onModifiedNameEntry: aRequest [
	
	"Invalidate source parent always"
	self invalidateParent: aRequest name.
	aRequest underName  ifNotNil: [ :parentDN |
			self invalidateName: parentDN.
	].
	
	main invalidatePage: aRequest name.
	self inform: 'Success on modyfying attributes in ', aRequest name

]

{ #category : 'dispatching' }
LDAPEditor >> sendAddEntryRequest: aPresenter [

	| aRequest |
	lastAddedAttributes := aPresenter filledAttributes.

	aRequest := aPresenter addRequest.
	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onAddedEntry: aRequest name ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendDeleteEntryRequest: aDN [

	| aRequest |
	aRequest := LDAPDeleteRequest new name: aDN.

	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onDeletedEntry: aDN ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendModifyNameRequest: aPresenter [

	| aRequest |
	aRequest := aPresenter modifyRequest.
	aRequest ifNil: [ ^ self ].
	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onModifiedNameEntry: aRequest ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendModifyRequest: aPresenter [

	| aRequest |
	aRequest := aPresenter modifyRequest.
	aRequest operations ifEmpty: [ ^ self inform: 'No change for entry ', aRequest name ].
	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onModifiedEntry: aRequest name ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'accessing' }
LDAPEditor >> subSchema [

	^ session subSchema
]
