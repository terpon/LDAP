"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parent',
		'table',
		'attributes',
		'help',
		'parentLabel',
		'toolbar'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPAttributePresenter class >> example [
	| aModel |
	aModel := {
		LDAPAttributeElement new description: 'objectClass'; content: 'person'; yourself.
		LDAPAttributeElement new description: 'cn'; content: 'foo'; state: true; yourself.
		LDAPAttributeElement new description: 'sn'; content: 'bar'; yourself.
		LDAPAttributeElement new description: 'sn'; content: 'nox'; yourself.
	}.
	^ (self on: aModel) openDialog

]

{ #category : 'adding' }
LDAPAttributePresenter >> addNewElement [

	attributes := attributes copyWith: LDAPAttributeElement new.
	self updatePresenter.
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> attributes [
	
	^ attributes ifNil: [ attributes := { LDAPAttributeElement new } ]
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> attributes: aCollection [
	
	attributes := aCollection
]

{ #category : 'testing' }
LDAPAttributePresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| bag |
	table refresh.
	bag := attributes reject: [ :element | element description isEmpty and: [ element content isEmpty ] ].

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
LDAPAttributePresenter >> colorFor: anAttribute [

	(anAttribute description isEmpty and: [ anAttribute content isNotEmpty ]) ifTrue: [ ^ self errorColor ].
	
	anAttribute state ifFalse: [ ^ self defaultColor ].
	
	anAttribute content isEmpty ifTrue: [ ^ self errorColor ].

	((attributes count: [ :a | a state and: [a description = anAttribute description] ]) > 1) ifTrue: [ ^ self errorColor ].
	
	^ self emphasisColor
]

{ #category : 'initialization' }
LDAPAttributePresenter >> connectPresenters [ 

	table whenSelectionChangedDo: [ :s | self inform: s printString ].
]

{ #category : 'private - accessing' }
LDAPAttributePresenter >> content: aString for: anAttribute [

	anAttribute content: aString.

]

{ #category : 'initialization' }
LDAPAttributePresenter >> contentColumn [ 

	^ SpStringTableColumn new
			title: 'Value'; 
			beEditable;
			displayBold: [ :each | each state ];
			displayColor: [ :each | self colorFor: each ];
			evaluated: [ :each | each content ];
			onTextChanged: [ :each :value | self content: value for: each ];
			onAcceptEdition: [ table refresh ]
			yourself
]

{ #category : 'coloring' }
LDAPAttributePresenter >> defaultColor [

	^ (SHRBTextStyler attributesFor: #default) ifEmpty: [ self theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'layout' }
LDAPAttributePresenter >> defaultLayout [ 

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

{ #category : 'private - accessing' }
LDAPAttributePresenter >> description: aString for: anAttribute [

	anAttribute description: aString.

]

{ #category : 'initialization' }
LDAPAttributePresenter >> descriptionColumn [ 
	
	^ SpStringTableColumn new
			title: 'Attribute';
			beEditable;
			displayBold: [ :each | each state ];
			displayColor: [ :each | self colorFor: each ];
			evaluated: [ :each | each description ];
			onTextChanged: [ :each :value | self description: value for: each ];
			onAcceptEdition: [ table refresh ];
			yourself
]

{ #category : 'coloring' }
LDAPAttributePresenter >> emphasisColor [

	^ (SHRBTextStyler attributesFor: #globalVar) ifEmpty: [ self theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'coloring' }
LDAPAttributePresenter >> errorColor [

	^ (SHRBTextStyler attributesFor: #invalid) ifEmpty: [ Color red ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'initialization' }
LDAPAttributePresenter >> initializeDialogWindow: aDialogWindowPresenter [
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
LDAPAttributePresenter >> initializePresenters [ 

	parentLabel := self newLabel label: 'Parent DN '.
	parent := self newTextInput beNotEditable.
	help := self newText beNotEditable; beWrapWord; withoutScrollBars;
		text: 'Check the attributes to be used as relative distinguished name'.
	toolbar := self newToolbar beIcons;
		add: (self newToolbarButton label: 'add';
				  			icon: (self iconNamed: #smallAdd);
				     		help: 'Add a new attribute line';
				       	action: [ self addNewElement ];
				        	yourself); yourself.
	table := self newTable
		isResizable: true;
		addColumn: self stateColumn;
		addColumn: self descriptionColumn;
		addColumn: self contentColumn;
		yourself.
]

{ #category : 'initialization' }
LDAPAttributePresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter title: 'Attributes for a new entry'.
]

{ #category : 'accessing' }
LDAPAttributePresenter >> parent: aString [

	parent text: aString 
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModel: aCollectionOfPairs [

	self attributes: aCollectionOfPairs.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModelBeforeInitialization: aCollectionOfPairs [

	self attributes: aCollectionOfPairs.

]

{ #category : 'private - accessing' }
LDAPAttributePresenter >> state: aBoolean for: anAttribute [

	anAttribute state: aBoolean.
	table refresh.
]

{ #category : 'initialization' }
LDAPAttributePresenter >> stateColumn [ 

	^ SpCheckBoxTableColumn new
			beNotExpandable; width: 20;
			onActivation: [ :each | self state: true for: each ];
			onDeactivation: [ :each | self state: false for: each ];
			evaluated: [ :each | each state ];
			yourself
]

{ #category : 'initialization' }
LDAPAttributePresenter >> updatePresenter [
 
	table items: attributes
]
