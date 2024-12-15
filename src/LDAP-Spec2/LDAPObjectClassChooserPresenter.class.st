"
I am a presenter to choose Object Classes when creating or editing entries
"
Class {
	#name : 'LDAPObjectClassChooserPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'schema',
		'classes',
		'mustAttributes',
		'mayAttributes',
		'description'
	],
	#category : 'LDAP-Spec2-Windows',
	#package : 'LDAP-Spec2',
	#tag : 'Windows'
}

{ #category : 'examples' }
LDAPObjectClassChooserPresenter class >> example [

	| classes |
	classes := LDAPSchema default structuralClasses select: [ :c | c hasAttribute: 'ou' ].
	^ (self on: classes) openDialog 
		okAction: [ :dialog | dialog inform: (dialog presenter selectedItems collect: #name) ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
]

{ #category : 'testing' }
LDAPObjectClassChooserPresenter >> checkOkTrigger [
"At least one object class must be selected"
	self selectedItems ifEmpty: [ self inform: 'At least one Object Class must be selected'. ^ false ].
		
	^ true
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> connectPresenters [

	classes 
		onActivation: [ :i | self updateAttributes ];
		onDeactivation: [ :i | self updateAttributes ];
		whenSelectionChangedDo: [ :selection | self updateDescription: selection selectedItem ].
		
	mustAttributes whenSelectionChangedDo: [ :selection | self updateDescription: selection selectedItem ].
	mayAttributes whenSelectionChangedDo: [ :selection | self updateDescription: selection selectedItem ].

]

{ #category : 'layout' }
LDAPObjectClassChooserPresenter >> defaultLayout [

	| classesLayout attributesLayout |
	classesLayout := SpBoxLayout newTopToBottom
		add: 'Object Classes' expand: false;
		add: classes;
		yourself.
	
	attributesLayout := SpBoxLayout newTopToBottom
		spacing: 5;
		add: 'Attributes' expand: false;
		add: mustAttributes;
		add: mayAttributes;
		yourself.
		
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpPanedLayout newLeftToRight
			add: classesLayout;
			add: attributesLayout;
			yourself);
		add: description expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	 "Override OK button to add check"
	
	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Ok' do: [ :presenter |
			self checkOkTrigger ifTrue: [ 
				presenter triggerOkAction.
				presenter close ] ]
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> initializePresenters [

	classes := (self instantiate: SpFilteringSelectableListPresenter)
		display: [ :item | item displayName ];
		items: self model;
		yourself.

	mustAttributes := self newList
		display: [ :item | item displayName ];
		headerTitle: 'Required Attributes';
		yourself.

	mayAttributes := self newList
		display: [ :item | item displayName ];
		headerTitle: 'Allowed Attributes';
		yourself.
		
	description := self newTextInput beNotEditable.
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Select Object Classes';
		initialExtent: 550 @ 500
]

{ #category : 'accessing' }
LDAPObjectClassChooserPresenter >> model [
	
	| model |
	super model ifNotNil: [ :m | ^m ].
	
	model := self schema structuralClasses.
	self model: model.
	^ model
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> modelChanged [ 

	classes items: self model.
]

{ #category : 'accessing' }
LDAPObjectClassChooserPresenter >> schema [

	^ schema ifNil: [ LDAPSchema default ]
]

{ #category : 'accessing' }
LDAPObjectClassChooserPresenter >> schema: anObject [

	schema := anObject
]

{ #category : 'api - selection' }
LDAPObjectClassChooserPresenter >> selectedItems [

	^ classes selectedItems reject: #isNil
]

{ #category : 'updating' }
LDAPObjectClassChooserPresenter >> updateAttributes [

	self updateAttributes: self selectedItems
]

{ #category : 'updating' }
LDAPObjectClassChooserPresenter >> updateAttributes: aCollection [

	| attributes |
	attributes := LDAPObjectClass attributesFrom: aCollection.
	mustAttributes items: attributes first sorted.
	mayAttributes items: attributes second sorted.
]

{ #category : 'updating' }
LDAPObjectClassChooserPresenter >> updateDescription: aSource [

	| names |
	aSource ifNil: [ ^self ].

	names := String streamContents: [ :aStream |	
		aSource names ifEmpty: [ aStream nextPutAll: aSource asString ]
		ifNotEmpty: [ :list |
			aStream nextPutAll: list first; nextPutAll: ' ('.
			list allButFirstDo: [ :n | aStream nextPutAll: n; nextPutAll: ', ' ].
			aStream nextPutAll: aSource oid asString; nextPut: $)
		]
	].

	description text: (aSource description
		ifNotEmpty: [ :string | String streamContents:[ :out | out << aSource name << ': ' << string ] ]
		ifEmpty: [ names ]).
	
	description help: names. 
	"Does not update help with morphic"	
	description withAdapterDo: [ :anAdapter | anAdapter setBalloonText: description help ]
]
