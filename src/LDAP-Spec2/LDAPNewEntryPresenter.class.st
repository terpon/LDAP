"
I am the presenter opened when a new entry is created. Attributes for that entry are filled here.
"
Class {
	#name : 'LDAPNewEntryPresenter',
	#superclass : 'LDAPAttributePresenter',
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'accessing - model' }
LDAPNewEntryPresenter >> addRequest [

	| name lines attrs |
	lines := self attributes select: [ :element | element isValid ].
	attrs := self attributesAsDictionary: lines.		
	name := self name.
	
	^ LDAPAddRequest new name: name; attributes: attrs
]

{ #category : 'private' }
LDAPNewEntryPresenter >> boldFor: anAttribute [

	^ anAttribute state
]

{ #category : 'testing' }
LDAPNewEntryPresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| bag |
	table refresh.
	bag := self attributes reject: [ :element | element isEmpty ].

	bag detect: [ :element | element state and: [ element content isEmpty] ]
		ifFound: [ :element | self inform: 'Attribute ''', element description, ''' for RDN has no value'. ^ false ].
	
	"Ignore attributes with no content"	
	bag := bag reject: [ :element | element content isEmpty ].
	bag detect: [ :element | element description isEmpty ]
		ifFound: [ :element | self inform: 'Attribute value ''', element content, ''' has no name'. ^ false ].
		
	bag := bag select: [ :element | element state ].
	bag ifEmpty: [ self inform: 'No attribute selected for Relative Distinguished Name'. ^ false ].
	
	bag := bag asBag collect: [ :element | element description ].
	bag associationsDo: [ :a | a value > 1 
		ifTrue: [ self inform: 'Multiple attributes with type ''', a key, ''' used for RDN'. ^ false ] ].
	^ true
]

{ #category : 'private' }
LDAPNewEntryPresenter >> colorFor: anAttribute [

	(anAttribute description isEmpty and: [ anAttribute content isNotEmpty ]) ifTrue: [ ^ self errorColor ].
	
	anAttribute state ifFalse: [ ^ self defaultColor ].
	
	anAttribute content isEmpty ifTrue: [ ^ self errorColor ].

	((self attributes count: [ :a | a state and: [a description = anAttribute description] ]) > 1) ifTrue: [ ^ self errorColor ].
	
	^ self emphasisColor
	
]

{ #category : 'layout' }
LDAPNewEntryPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: table;
		add: toolbar expand: false;
		add: help expand: false;
		yourself
]

{ #category : 'coloring' }
LDAPNewEntryPresenter >> emphasisColor [

	^ (SHRBTextStyler attributesFor: #globalVar) ifEmpty: [ self theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'initialization' }
LDAPNewEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	help text: 'Check the attributes to be used as relative distinguished name'.
	
	table 
		addColumn: self stateColumn;
		addColumn: self descriptionColumn beEditable;
		addColumn: self contentColumn beEditable.

]

{ #category : 'initialization' }
LDAPNewEntryPresenter >> initializeWindow: aWindowPresenter [
	
	| height |
	super initializeWindow: aWindowPresenter.
	
	height := self attributes size min: 20 max: 8.
	height := StandardFonts defaultFont lineGrid * (height + 7) * 1.5.
	
	aWindowPresenter 
		title: 'Attributes for a new entry';
		initialExtent: 400 @ height
]

{ #category : 'accessing - model' }
LDAPNewEntryPresenter >> name [

	^ String streamContents: [ :out |
		(self attributes select: [ :element | element isValid and: [ element state ] ])
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
		parent text ifNotEmpty: [ :string | out nextPut: $,; nextPutAll: string ]
	]
]

{ #category : 'accessing' }
LDAPNewEntryPresenter >> parent: aString [

	parent text: aString 
]
