"
I am a presenter to display BER elements as trees in the inspector.
"
Class {
	#name : 'BERElementTreePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roots',
		'tree'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
BERElementTreePresenter class >> example [
"Sample tree"
	| mod |
	mod := self sampleElement.
	^ self new root: mod; open

]

{ #category : 'examples' }
BERElementTreePresenter class >> exampleInspect [
"Sample tree"
	self sampleElement inspect.

]

{ #category : 'examples' }
BERElementTreePresenter class >> sampleElement [
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

{ #category : 'forwarding' }
BERElementTreePresenter >> activateOnSingleClick [
	tree activateOnSingleClick.
]

{ #category : 'initialization' }
BERElementTreePresenter >> connectPresenters [ 

	super connectPresenters.

	tree whenActivatedDo: [ :event | self toggleExpandCurrent ].
		

]

{ #category : 'layout' }
BERElementTreePresenter >> defaultLayout [ 
	^ SpBoxLayout newVertical add: #tree; yourself
]

{ #category : 'controlling' }
BERElementTreePresenter >> expand [
	tree expandRoots.
]

{ #category : 'initialization' }
BERElementTreePresenter >> initializePresenters [ 

	tree := self newTreeTable 
		isResizable: true;
		addColumn: (SpStringTableColumn title: 'Class' evaluated: [ :e | self printClassFor: e ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :e | e displayString ]);
		children: [ :e | e elements ];
		yourself.
	

]

{ #category : 'initialization' }
BERElementTreePresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	aSpWindowPresenter
		title: self titleForWindow
]

{ #category : 'accessing - model' }
BERElementTreePresenter >> model [

	roots size = 1 ifTrue: [ ^ roots first ].
	^ roots
	
]

{ #category : 'ports' }
BERElementTreePresenter >> outputActivationPort [ 
	^ tree outputActivationPort
]

{ #category : 'printing' }
BERElementTreePresenter >> printClassFor: anObject [ 

	^ String streamContents: [ :s | 
				s << anObject class name.
				anObject elements ifNotEmpty: [ :children | s << ' (' << children size asString << ')' ] ]
]

{ #category : 'accessing' }
BERElementTreePresenter >> root: anObject [
	^ self roots: { anObject }
	
]

{ #category : 'accessing' }
BERElementTreePresenter >> roots: aCollection [
	roots := aCollection.
	self updatePresenter.
	
]

{ #category : 'accessing' }
BERElementTreePresenter >> selectedItem [
	"Return selected item."
	
	^ tree selectedItem
]

{ #category : 'accessing - model' }
BERElementTreePresenter >> setModel: aModel [

	self roots: (aModel isCollection ifTrue: [ aModel ] ifFalse: [ { aModel } ])
	
]

{ #category : 'accessing - model' }
BERElementTreePresenter >> setModelBeforeInitialization: aModel [

	roots := aModel isCollection ifTrue: [ aModel ] ifFalse: [ { aModel } ]
]

{ #category : 'initialization' }
BERElementTreePresenter >> titleForWindow [ 
	roots ifNil: [ ^ self className ].
	roots size = 1 ifTrue: [ ^ roots first displayString ].
	^ roots displayString
]

{ #category : 'controlling' }
BERElementTreePresenter >> toggleExpandCurrent [
	| path state |
	path := tree selection selectedPath.
	path ifNil: [ ^ self ].
	state := tree isExpanded: path.
	state ifTrue: [ tree collapsePath: path ] ifFalse: [ tree expandPath: path ].
	tree selectPath: path.
]

{ #category : 'initialization' }
BERElementTreePresenter >> updatePresenter [ 
	| elements |
	elements := roots ifNil: [ #() ].
	tree roots: elements.
	
	self withWindowDo: [ :w | w title: self titleForWindow ]
]

{ #category : 'enumerating' }
BERElementTreePresenter >> whenActivatedDo: aBlock [
	tree whenActivatedDo: aBlock.
]
