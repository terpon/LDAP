"
I am the presenter opened when a new entry is created. Attributes for that entry are filled here.
"
Class {
	#name : 'LDAPNewEntryPresenter',
	#superclass : 'LDAPAttributeTablePresenter',
	#instVars : [
		'help'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'examples' }
LDAPNewEntryPresenter class >> example [
	| aModel aPresenter aDialog |
	aModel := {
		LDAPLeafEntryAttribute newFromPair: #( 'objectClass' 'person' ).
		LDAPKeyEntryAttribute newFromPair: #( 'cn' 'foo' ).
		LDAPLeafEntryAttribute newFromPair: #( 'sn' 'bar' ).
		LDAPLeafEntryAttribute newFromPair: #( 'sn' 'nox' ).
	}.
	aPresenter := self on: aModel.
	aPresenter parent: 'dc=example,dc=com'.
	aDialog := aPresenter openDialog 
		okAction: [ :dialog | dialog presenter addRequest inspect ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
	^ aPresenter

]

{ #category : 'accessing - model' }
LDAPNewEntryPresenter >> addRequest [

	| name attrs |
	attrs := self attributesAsDictionary: self asAttributes.		
	name := self name.
	
	^ LDAPAddRequest new name: name; attributes: attrs
]

{ #category : 'testing' }
LDAPNewEntryPresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| rdn |
	rdn := lines select: #isKey.
	rdn ifEmpty: [ self inform: 'No attributes selected for Relative Distinguished Name'. ^ false ].
	
	rdn detect: [ :element | element content isEmpty ]
		ifFound: [ :element | self inform: 'Attribute ''', element description, ''' for RDN has no value'. ^ false ].
	
	(rdn collect: #description) asBag keysAndValuesDo: [ :description :count | count > 1 
		ifTrue: [ self inform: 'Multiple attributes with type ''', description, ''' used for RDN'. ^ false ] ].

	^ super checkOkTrigger
]

{ #category : 'private' }
LDAPNewEntryPresenter >> colorFor: anAttribute [

"	((self attributes count: [ :a | a isKey and: [a description = anAttribute description] ]) > 1) ifTrue: [ ^ application errorColor ].
	"
	^ super colorFor: anAttribute 
	
]

{ #category : 'layout' }
LDAPNewEntryPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: table;
		add: help expand: false;
		yourself
]

{ #category : 'private' }
LDAPNewEntryPresenter >> iconFor: anAttribute [

	anAttribute isSpecial ifTrue: [ ^ anAttribute icon ].
	anAttribute isRequired ifTrue: [ ^ self iconNamed: #testGreen ].
	anAttribute isKnown ifTrue: [ ^ self iconNamed: #testYellow ].
	^ self iconNamed: #testNotRun
]

{ #category : 'initialization' }
LDAPNewEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	help := self newText beNotEditable; beWrapWord; withoutScrollBars;
		text: 'Check the attributes to be used as relative distinguished name'.
	
	table 
		addColumn: self keyColumn;
		addColumn: self descriptionColumn;
		addColumn: self contentColumn;
		addColumns: self actionsColumns.

]

{ #category : 'initialization' }
LDAPNewEntryPresenter >> initializeWindow: aWindowPresenter [
	
	| height |
	super initializeWindow: aWindowPresenter.
	
	height := self numberOfLines min: 20 max: 8.
	height := StandardFonts defaultFont lineGrid * (height + 8) * 1.5.
	
	aWindowPresenter 
		title: 'Attributes for a new entry';
		initialExtent: 450 @ height
]

{ #category : 'ui building' }
LDAPNewEntryPresenter >> keyColumn [

	^ SpColumnViewColumn new
			width: 23;
			setup: [ :aPresenter | aPresenter newPresenter layout: SpBoxLayout newLeftToRight; yourself ];
			bind: [ :aPresenter :anAttribute | anAttribute keyCheckbox: aPresenter for: self ];
			yourself

]

{ #category : 'accessing' }
LDAPNewEntryPresenter >> name [

	^ String streamContents: [ :out |
		(self asAttributes select: #isKey)
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
		parent text ifNotEmpty: [ :string | out nextPut: $,; nextPutAll: string ]
	]
]

{ #category : 'accessing' }
LDAPNewEntryPresenter >> parent: aString [

	parent text: aString 
]
