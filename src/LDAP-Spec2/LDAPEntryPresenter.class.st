"
I am a presenter to display BER elements as trees in the inspector.
"
Class {
	#name : 'LDAPEntryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'entry',
		'table'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
LDAPEntryPresenter class >> defaultLayout [ 
	^ SpBoxLayout newVertical add: #table; yourself
]

{ #category : 'specs' }
LDAPEntryPresenter class >> defaultSpec [

	^ self defaultLayout
]

{ #category : 'examples' }
LDAPEntryPresenter class >> example [
"Sample tree"
	| result adapter |
	result := self sampleElement.
	adapter := LDAPSearchResultEntryAdapter new entry: result.
	^ self new entry: adapter; open

]

{ #category : 'examples' }
LDAPEntryPresenter class >> exampleInspect [
"Sample tree"
	self sampleElement inspect.

]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleElement [
"Sample search result"
	| entry list |
	entry := LDAPSearchResultEntry new.
	entry addElement: (BEROctetString new value: 'cn=test4,dc=example,dc=com').
	list := LDAPPartialAttributeList new addAll: { 
				LDAPPartialAttribute new description: 'objectClass'; values: 'person'; yourself.
				LDAPPartialAttribute new description: 'cn'; values: 'Haddock'; yourself.
				LDAPPartialAttribute new description: 'sn'; values: { 'Haddock'. 'Capitaine' }; yourself 
			 }; yourself.
	entry addElement: list.
	^ entry

]

{ #category : 'opening' }
LDAPEntryPresenter class >> show: anEntry [
	^ self new entry: anEntry; open

]

{ #category : 'forwarding' }
LDAPEntryPresenter >> activateOnSingleClick [
	table activateOnSingleClick.
]

{ #category : 'initialization' }
LDAPEntryPresenter >> connectPresenters [ 

	super connectPresenters.

]

{ #category : 'accessing' }
LDAPEntryPresenter >> entry [
	
	^ entry ifNil: [ entry := LDAPNullEntryAdapter new ]
]

{ #category : 'accessing' }
LDAPEntryPresenter >> entry: anObject [
	entry := anObject.
	self updatePresenter.
	
]

{ #category : 'initialization' }
LDAPEntryPresenter >> initializePresenters [ 

	table := self newTable
		isResizable: true;
		addColumn: (SpStringTableColumn title: 'Attribute' evaluated: [ :each | each first ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :each | each second ]);
		yourself.
	

]

{ #category : 'initialization' }
LDAPEntryPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter
		title: self titleForWindow
]

{ #category : 'ports' }
LDAPEntryPresenter >> outputActivationPort [ 
	^ table outputActivationPort
]

{ #category : 'accessing' }
LDAPEntryPresenter >> selectedItem [
	"Return selected item."
	
	^ table selectedItem
]

{ #category : 'initialization' }
LDAPEntryPresenter >> titleForWindow [ 

	^ self entry dn ifEmpty: [ self className ]
]

{ #category : 'initialization' }
LDAPEntryPresenter >> updatePresenter [ 

	table items: self entry attributes.
	self withWindowDo: [ :w | w title: self titleForWindow ]
]

{ #category : 'enumerating' }
LDAPEntryPresenter >> whenActivatedDo: aBlock [
	table whenActivatedDo: aBlock.
]
