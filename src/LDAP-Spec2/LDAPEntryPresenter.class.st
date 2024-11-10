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
	| mod |
	mod := self sampleElement.
	^ self new root: mod; open

]

{ #category : 'examples' }
LDAPEntryPresenter class >> exampleInspect [
"Sample tree"
	self sampleElement inspect.

]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleElement [
"Sample tree"
	| ops |
	ops :=  { 
		LDAPAttrModifier set: 'sn' to: { 'test' . 'foo' . 'bar'}.
		LDAPAttrModifier addTo: 'description' values: {'moo'}.
		LDAPAttrModifier del: 'color'.
		LDAPAttrModifier delFrom: 'groups' values: {'ni'}.
	}.

	^ LDAPModifyRequest new dn: 'cn=a,dc=root'; ops: ops.

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
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :each | self showValue: each second ]);
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

{ #category : 'formatting' }
LDAPEntryPresenter >> showValue: aCollection [

	^ String streamContents: [ :out | out << (aCollection do: [ :e | e ] separatedBy: [ ', ' ]) ]
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
