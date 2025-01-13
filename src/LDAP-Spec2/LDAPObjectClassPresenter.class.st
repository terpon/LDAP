"
I am a presenter to choose Object Classes when creating or editing entries
"
Class {
	#name : 'LDAPObjectClassPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'name',
		'description',
		'superiors',
		'mustAttributes',
		'mayAttributes'
	],
	#category : 'LDAP-Spec2-Schema',
	#package : 'LDAP-Spec2',
	#tag : 'Schema'
}

{ #category : 'examples' }
LDAPObjectClassPresenter class >> example [

	| class |
	class := LDAPSchema default objectClass: 'inetOrgPerson' ifAbsent: [nil].
	^ (self on: class) open
]

{ #category : 'updating' }
LDAPObjectClassPresenter >> collectSuperiors: aCollection [

	| list sup |
	list := OrderedCollection new.
	sup := aCollection.
	
	[ sup isEmpty ] whileFalse: [
		list addAllFirst: sup.
		sup := sup flatCollect: #superiors.
	].

	^ list removeDuplicates
]

{ #category : 'layout' }
LDAPObjectClassPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: name expand: false;
		add: description expand: false;
		add: superiors;
		add: mustAttributes;
		add: mayAttributes;
		yourself.
]

{ #category : 'initialization' }
LDAPObjectClassPresenter >> initializePresenters [

	name := self newTextInput beNotEditable.
	description := self newTextInput beNotEditable.
		
	superiors := self newList
		display: [ :item | item displayName ];
		headerTitle: 'Inherits from';
		yourself.

	mustAttributes := self newList
		display: [ :item | item displayName ];
		headerTitle: 'Required Attributes';
		yourself.

	mayAttributes := self newList
		display: [ :item | item displayName ];
		headerTitle: 'Allowed Attributes';
		yourself.
]

{ #category : 'initialization' }
LDAPObjectClassPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Object Class';
		initialExtent: 250 @ 510
]

{ #category : 'initialization' }
LDAPObjectClassPresenter >> modelChanged [ 

	| model |
	model := self model ifNil: [ ^self reset ].
	name text: model displayName.
	description text: model description.
	superiors items: (self collectSuperiors: model superiors).
	mustAttributes items: model must sorted.
	mayAttributes items: model may sorted.
]

{ #category : 'initialization' }
LDAPObjectClassPresenter >> reset [ 

	name text: ''.
	description text: ''.
	superiors items: #().
	mustAttributes items: #().
	mayAttributes items: #().
]

{ #category : 'layout' }
LDAPObjectClassPresenter >> schemaLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: description expand: false;
		add: superiors;
		add: mustAttributes;
		add: mayAttributes;
		yourself.
]
