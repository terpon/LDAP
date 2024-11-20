"
I am a presenter to display LDAP result codes (especially errors)
"
Class {
	#name : 'LDAPResultPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
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

{ #category : 'examples' }
LDAPResultPresenter class >> exampleInspect [
"Sample tree"
	self sampleElement inspect.

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

{ #category : 'initialization' }
LDAPResultPresenter >> connectPresenters [ 

	super connectPresenters.

]

{ #category : 'layout' }
LDAPResultPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight hAlignCenter; add: #code) expand: false;
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

	code := self newLabel displayBold; yourself.
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

	aSpWindowPresenter
		title: result className
]

{ #category : 'accessing - model' }
LDAPResultPresenter >> setModel: aDomainObject [

	result := aDomainObject.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPResultPresenter >> setModelBeforeInitialization: aDomainObject [

	result := aDomainObject
]

{ #category : 'initialization' }
LDAPResultPresenter >> updatePresenter [ 

	code label: result resultElement displayString.
	name label: result name.
	message text: result diagnosticMessage.
]
