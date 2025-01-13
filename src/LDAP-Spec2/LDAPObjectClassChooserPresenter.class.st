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
	#category : 'LDAP-Spec2-Schema',
	#package : 'LDAP-Spec2',
	#tag : 'Schema'
}

{ #category : 'examples' }
LDAPObjectClassChooserPresenter class >> example [

	| classes presenter |
	classes := LDAPSchema default structuralClasses select: [ :c | c hasAttribute: 'ou' ].
	presenter := self on: classes.
	presenter selectItem: 'groupofnames'.
	^ presenter openDialog 
		okAction: [ :dialog | dialog inform: (dialog presenter selectedItem name) ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
]

{ #category : 'examples' }
LDAPObjectClassChooserPresenter class >> exampleDefault [

	^ (self on: LDAPSchema default structuralClasses) openDialog
]

{ #category : 'examples' }
LDAPObjectClassChooserPresenter class >> exampleEmpty [

	^ self new openDialog
]

{ #category : 'testing' }
LDAPObjectClassChooserPresenter >> checkOkTrigger [
"One object class must be selected"
	self selectedItem ifNil: [ self inform: 'No Object Class selected'. ^ false ].
		
	^ true
]

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> connectPresenters [

	classes whenSelectionChangedDo: [ :selection | self updateAttributes ].
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

	classes := (self instantiate: SpFilteringListPresenter)
		display: [ :item | item displayName ];
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

{ #category : 'initialization' }
LDAPObjectClassChooserPresenter >> modelChanged [ 

	| list |
	list := self model ifNil: [ #() ] ifNotNil: [ :m | m sorted ].
	classes items: list.
]

{ #category : 'accessing' }
LDAPObjectClassChooserPresenter >> schema [

	^ application schema
]

{ #category : 'api - selection' }
LDAPObjectClassChooserPresenter >> selectItem: aName [

	| oc |
	oc := aName isString ifFalse: [ aName ] ifTrue: [ self schema objectClass: aName ifAbsent: [ nil ] ].
	classes selectItem: oc.
	self updateAttributes
]

{ #category : 'api - selection' }
LDAPObjectClassChooserPresenter >> selectedItem [

	^ classes selectedItem
]

{ #category : 'updating' }
LDAPObjectClassChooserPresenter >> updateAttributes [

	| oc |
	oc := self selectedItem ifNil: [ ^self ].
	mustAttributes items: (oc must reject: [ :each | each oid = '2.5.4.0']) sorted.
	mayAttributes items: oc may sorted.
	
	self updateDescription: oc.
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
