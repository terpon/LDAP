Class {
	#name : #BERElementTreePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roots',
		'tree'
	],
	#category : #'LDAP-Spec2'
}

{ #category : #accessing }
BERElementTreePresenter class >> childrenBlock [ 

	^ [ :e | (e isKindOf: BERConstruct) ifFalse: [ #() ] ifTrue: [ e value ] ]
]

{ #category : #accessing }
BERElementTreePresenter class >> classBlock [ 

	^ [ :e | (e isKindOf: BERConstruct) 
			ifFalse: [ e class name ] 
			ifTrue: [ String streamContents: [ :s | s << e class name << ' (' << e value size asString << ')' ] ]
		]
]

{ #category : #initialization }
BERElementTreePresenter class >> defaultLayout [ 
	^ SpBoxLayout newVertical add: #tree; yourself
]

{ #category : #specs }
BERElementTreePresenter class >> defaultSpec [

	^ self defaultLayout
]

{ #category : #accessing }
BERElementTreePresenter class >> valueBlock [ 

	^ [ :e | (e isKindOf: BERConstruct) ifFalse: [ e ] ifTrue: [ nil ] ]
]

{ #category : #forwarding }
BERElementTreePresenter >> activateOnSingleClick [
	tree activateOnSingleClick.
]

{ #category : #controlling }
BERElementTreePresenter >> expand [
	tree expandRoots.
]

{ #category : #initialization }
BERElementTreePresenter >> initializePresenters [ 

	tree := self newTreeTable 
		isResizable: true;
		addColumn: (SpStringTableColumn title: 'Class' evaluated: self class classBlock);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: self class valueBlock);
		children: self class childrenBlock;
		yourself.
		
	self updatePresenter.
]

{ #category : #ports }
BERElementTreePresenter >> outputActivationPort [ 
	^ tree outputActivationPort
]

{ #category : #accessing }
BERElementTreePresenter >> root: anObject [
	^ self roots: { anObject }
	
]

{ #category : #accessing }
BERElementTreePresenter >> roots: aCollection [
	roots := aCollection.
	self updatePresenter.
	
]

{ #category : #accessing }
BERElementTreePresenter >> selectedItem [
	"Return selected item."
	
	^ tree selectedItem
]

{ #category : #initialization }
BERElementTreePresenter >> updatePresenter [ 

	tree roots: (roots ifNil: [ { BERNull new } ]).
]

{ #category : #enumerating }
BERElementTreePresenter >> whenActivatedDo: aBlock [
	tree whenActivatedDo: aBlock.
]
