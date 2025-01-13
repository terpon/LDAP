"
I add edition commands to the LDAP browser.
"
Class {
	#name : 'LDAPEditor',
	#superclass : 'LDAPBrowser',
	#instVars : [
		'clipboard',
		'schema'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'instance creation' }
LDAPEditor class >> mainPresenterClass [

	^ LDAPEditorPresenter
]

{ #category : 'clipboard handling' }
LDAPEditor >> clipboard [

	^ clipboard ifNil: [ clipboard := LDAPClipboardNull new ]
]

{ #category : 'private - clipboard handling' }
LDAPEditor >> clipboard: aClipboardContent [
	
	(aClipboardContent = self clipboard) ifTrue: [ ^self ].
	clipboard := aClipboardContent.
	self announcer announce: (LDAPClipboardChanged new content: aClipboardContent)
]

{ #category : 'clipboard handling' }
LDAPEditor >> clipboardClear [
	
	self clipboard: LDAPClipboardNull new.
]

{ #category : 'clipboard handling' }
LDAPEditor >> clipboardCopy: anEntry [
	
	| copy attributes aDN |
	aDN := anEntry name.
	attributes := anEntry leaves collect: #copy.

	copy := LDAPClipboardCopyAttributes new name: aDN; attributes: attributes; yourself.
	self clipboard: copy
]

{ #category : 'clipboard handling' }
LDAPEditor >> clipboardCut: anEntry [
	
	| cut |
	cut := LDAPClipboardMoveEntry new name: anEntry name.
	self clipboard: cut
]

{ #category : 'searching' }
LDAPEditor >> invalidateName: aDN [
"Gets entry from the cache and invalidate it"
	| aCachedEntry |
	aCachedEntry := cache at: aDN.
	aCachedEntry invalidate.
	self isConnected ifTrue: [ aCachedEntry update: self ].
	
	(self clipboard isValidOnInvalidateName: aDN) ifFalse: [ self clipboardClear ].
]

{ #category : 'searching' }
LDAPEditor >> invalidateParent: aDN [
"Gets entry from the cache and invalidate it"
	| parentDN |
	parentDN := LDAPName parentOf: aDN.
	self invalidateName: parentDN
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
	self inform: 'Success on modyfying name for ', aRequest name

]

{ #category : 'callbacks' }
LDAPEditor >> onNamingContexts: aCommand [

	| search dn |
	super onNamingContexts: aCommand.
	dn := session subSchema ifNil: [ ^self ]. "No schema to load"
	
	self isConnected ifFalse: [ ^ self ].
	
	search := LDAPSearchRequest new
		          base: dn;
		          scope: LDAPBaseObjectScope new;
		          attributes: { '*' . '+' }.
		
	^ self sendRequest: search
		onSuccessDo: [ :command | self onSubSchema: command ]
		onFailureDo: [ :command | 
			schema := nil.
			self reportError: command. ].

]

{ #category : 'callbacks' }
LDAPEditor >> onSubSchema: aCommand [

	| searchResult syntaxes types classes |
	main notify: 'schema retrieved'.
	searchResult := aCommand responses first asDictionary.
	syntaxes := searchResult at: 'ldapsyntaxes' ifAbsent: [ #() ].
	types := searchResult at: 'attributetypes' ifAbsent: [ #() ].
	classes := searchResult at: 'objectclasses' ifAbsent: [ #() ].
	schema := LDAPSchema new
		parseSyntaxes: syntaxes;
		parseTypes: types;
		parseClasses: classes;
		build.
]

{ #category : 'ui - dialogs' }
LDAPEditor >> openNewEntryDialogUnder: aDN with: aCollection [
	
	| aPresenter |
	aPresenter := LDAPNewEntryPresenter newApplication: self model: aCollection.
	aPresenter parent: aDN.

	^ aPresenter openDialog
		okAction: [ :dialog | | presenter |
			presenter := dialog presenter.
			self sendAddEntry: presenter addRequest
		];
		cancelAction: [ :dialog | dialog inform: 'Cancelled adding new entry in ' , aDN ];
		yourself
]

{ #category : 'ui - dialogs' }
LDAPEditor >> openSchema [
	
	^ (LDAPSchemaPresenter on: self schema) openDialog
]

{ #category : 'accessing' }
LDAPEditor >> schema [

	^ schema ifNil: [ LDAPSchema default ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendAddEntry: aRequest [

	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onAddedEntry: aRequest name ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendDeleteEntry: aDN [

	| aRequest |
	aRequest := LDAPDeleteRequest new name: aDN.

	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onDeletedEntry: aDN ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendModify: aRequest [

	aRequest operations ifEmpty: [ ^ self inform: 'No change for entry ', aRequest name ].
	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onModifiedEntry: aRequest name ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'dispatching' }
LDAPEditor >> sendModifyName: aRequest [

	aRequest ifNil: [ ^ self ].
	self sendRequest: aRequest 
		onSuccessDo: [ :command | self onModifiedNameEntry: aRequest ] 
		onFailureDo: [ :command | self reportError: command ]
]

{ #category : 'accessing' }
LDAPEditor >> subSchema [

	^ session subSchema
]
