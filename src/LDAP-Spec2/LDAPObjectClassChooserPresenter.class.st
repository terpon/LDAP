"
I am a presenter to choose Object Classes when creating or editing entries
"
Class {
	#name : 'LDAPObjectClassChooserPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'classes',
		'mustAttributes',
		'mayAttributes',
		'description'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPObjectClassChooserPresenter class >> example [

	^ (self on: LDAPSchema default) open.

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
		add: 'Required Attributes' expand: false;
		add: mustAttributes;
		add: 'Allowed Attributes' expand: false;
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
LDAPObjectClassChooserPresenter >> initializePresenters [

	classes := (self instantiate: SpFilteringSelectableListPresenter)
		display: [ :item | item displayName ];
		items: self objectClasses;
		yourself.

	mustAttributes := self newList
		display: [ :item | item displayName ];
		yourself.

	mayAttributes := self newList
		display: [ :item | item displayName ];
		yourself.
		
	description := self newTextInput beNotEditable.
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Select Object Classes';
		initialExtent: 550 @ 500
]

{ #category : 'accessing - model' }
LDAPObjectClassChooserPresenter >> objectClasses [
	
	^ self model ifNil: [ #() ] ifNotNil: [ :model | model structuralClasses ]
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
