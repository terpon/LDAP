"
I report LDAPResult codes and messages in a dialog window.

I limit the number of queued report and only open a window once at a time.
"
Class {
	#name : 'LDAPDialogErrorHandler',
	#superclass : 'LDAPErrorHandler',
	#instVars : [
		'dialog',
		'max',
		'queue'
	],
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'private - sizing' }
LDAPDialogErrorHandler >> clipQueue [

	(queue size > max) ifTrue: [ queue removeLast: (queue size - max) ]
]

{ #category : 'callbacks' }
LDAPDialogErrorHandler >> dialogClosed [

	queue ifEmpty: [ ^ self ].
	self openDialog.
]

{ #category : 'initialization' }
LDAPDialogErrorHandler >> initialize [ 

	super initialize.
	
	max := 10.
	queue := OrderedCollection new.
]

{ #category : 'showing' }
LDAPDialogErrorHandler >> openDialog [

	| result presenter |
	queue ifEmpty: [ ^ nil ].

	result := queue removeFirst.
	presenter := LDAPResultPresenter
		             newApplication: application
		             model: result.

	dialog ifNotNil: [ dialog open. ^ dialog ].
	dialog := presenter openDialog.
	dialog whenClosedDo: [ self dialogClosed ].
	^ dialog
]

{ #category : 'accessing' }
LDAPDialogErrorHandler >> queueSize: anInteger [

	max := anInteger.
	self clipQueue.
]

{ #category : 'reporting' }
LDAPDialogErrorHandler >> report: aLDAPResult [

	queue addLast: aLDAPResult.
	self clipQueue.
	
	self openDialog
]

{ #category : 'initialization' }
LDAPDialogErrorHandler >> reset [

	queue removeAll.
	dialog ifNotNil: [ dialog close ].
]
