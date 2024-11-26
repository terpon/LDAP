"
I report LDAPResult codes and messages in a dialog window.

I limit the number of queued report and only open a window once at a time.
"
Class {
	#name : 'LDAPDialogErrorHandler',
	#superclass : 'LDAPErrorHandler',
	#instVars : [
		'max',
		'queue',
		'lock'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'accessing' }
LDAPDialogErrorHandler >> at: anIndex [

	| element |
	element := lock critical: [queue at: anIndex].
	^ element
]

{ #category : 'private - sizing' }
LDAPDialogErrorHandler >> clipQueue [

	(queue size > max) ifTrue: [ queue removeLast: (queue size - max) ]
]

{ #category : 'initialization' }
LDAPDialogErrorHandler >> initialize [ 

	super initialize.
	
	max := 10.
	queue := OrderedCollection new.
	lock := Semaphore forMutualExclusion.

]

{ #category : 'showing' }
LDAPDialogErrorHandler >> openPresenter [

	| presenter |
	presenter := LDAPErrorPresenter
		             newApplication: application
		             model: self.

	^ presenter open
]

{ #category : 'accessing' }
LDAPDialogErrorHandler >> queueSize: anInteger [

	lock critical: [
		max := anInteger.
		self clipQueue.
	]
]

{ #category : 'removing' }
LDAPDialogErrorHandler >> removeAll [
	
	lock critical: [queue removeAll].
	self valueChanged
]

{ #category : 'removing' }
LDAPDialogErrorHandler >> removeAt: anIndex [

	| element |
	element := lock critical: [queue removeAt: anIndex].
	self valueChanged.
	^ element
]

{ #category : 'reporting' }
LDAPDialogErrorHandler >> report: aLDAPResult [

	lock critical: [
		(queue size >= max) ifTrue: [ ^ self ].
		queue addLast: aLDAPResult.
	].
	self valueChanged


]

{ #category : 'initialization' }
LDAPDialogErrorHandler >> reset [

	self removeAll.

]

{ #category : 'accessing' }
LDAPDialogErrorHandler >> size [

	^ queue size
]
