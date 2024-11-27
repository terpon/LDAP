"
I am a presenter to display LDAP result codes (especially errors)
"
Class {
	#name : 'LDAPResultPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'type',
		'result',
		'code',
		'name',
		'message'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPResultPresenter class >> example [
"Sample tree"
	| result |
	result := self sampleElement.
	^ self show: result

]

{ #category : 'opening' }
LDAPResultPresenter class >> exampleFullLayout [
	| p |
	p := self on: self sampleElement.
	p layout: p fullLayout.
	^ p openDialog


]

{ #category : 'examples' }
LDAPResultPresenter class >> sampleElement [
"Sample error result"

	^ LDAPBindResult new addAll: { 
		LDAPResultCode new value: 34. 
		BEROctetString new value: 'cn=foo,cn=bar'.
		BEROctetString new value: 'invalid DN'
	 }; yourself
]

{ #category : 'opening' }
LDAPResultPresenter class >> show: anEntry [
	^ (self on: anEntry) openDialog


]

{ #category : 'specs' }
LDAPResultPresenter class >> title [ 

	^ 'LDAPResult'
]

{ #category : 'layout' }
LDAPResultPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: #code expand: false;
		add: #name expand: false;
		add: #message;
		yourself
]

{ #category : 'layout' }
LDAPResultPresenter >> fullLayout [ 
	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: (SpBoxLayout newLeftToRight
			spacing: 5; vAlignCenter;
			add: #type expand: false; 
			add: #code; 
			yourself) expand: false;
		add: #name expand: false;
		add: #message;
		yourself
]

{ #category : 'initialization' }
LDAPResultPresenter >> initializeDialogWindow: aDialogPresenter [

	aDialogPresenter 
		withDecorations;
		addButton: 'OK' do: [ :dialog | dialog beOk; close ].
]

{ #category : 'initialization' }
LDAPResultPresenter >> initializePresenters [ 

	type := self newLabel.
	code := self newTextInput beNotEditable.
	name := self newLabel.
	message := self newText
		beNotWrapWord;
		propagateNaturalWidth: true;
		propagateNaturalHeight: false;
		editable: false;
		yourself.
]

{ #category : 'initialization' }
LDAPResultPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	result ifNotNil: [ aSpWindowPresenter title: result className ].
]

{ #category : 'initialization' }
LDAPResultPresenter >> reset [ 

	type label: 'LDAPResult'.
	code text: ''.
	name label: ''.
	message text: ''.
]

{ #category : 'accessing - model' }
LDAPResultPresenter >> result: aResult [

	result := aResult.
	self updatePresenter.
]

{ #category : 'accessing - model' }
LDAPResultPresenter >> setModel: aDomainObject [

	self result: aDomainObject
]

{ #category : 'accessing - model' }
LDAPResultPresenter >> setModelBeforeInitialization: aDomainObject [

	result := aDomainObject
]

{ #category : 'initialization' }
LDAPResultPresenter >> updatePresenter [ 

	result ifNil: [ ^ self reset ].
	
	type label: result className.
	code text: result resultElement displayString.
	name label: result name.
	message text: result diagnosticMessage.
]
