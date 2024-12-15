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
	#category : 'LDAP-Spec2-Windows',
	#package : 'LDAP-Spec2',
	#tag : 'Windows'
}

{ #category : 'adding' }
LDAPAttributePresenter >> addNewElement [

	self subclassResponsibility.
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> attributes [
	
	^ attributes ifNil: [ attributes := #() ]
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> attributes: aCollection [
	
	attributes := aCollection.
	self updatePresenter
]

{ #category : 'helper' }
LDAPAttributePresenter >> attributesAsDictionary: aCollection [
	
	| dictionary |
	dictionary := Dictionary new.
	aCollection do: [ :element | | value |
		value := element content.
		dictionary at: element description 
			update: [ :values | values add: value; yourself ] 
			initial: [ Set with: value ]
	].
	^ dictionary 

]

{ #category : 'private' }
LDAPAttributePresenter >> boldFor: anAttribute [

	self subclassResponsibility.	
	^ false 
]

{ #category : 'testing' }
LDAPAttributePresenter >> checkOkTrigger [

	self subclassResponsibility.
	^ true
]

{ #category : 'private' }
LDAPAttributePresenter >> colorFor: anAttribute [

	self subclassResponsibility.	
	^ self defaultColor 
]

{ #category : 'private - accessing' }
LDAPAttributePresenter >> content: aString for: anAttribute [

	anAttribute content: aString.

]

{ #category : 'initialization' }
LDAPAttributePresenter >> contentColumn [ 

	^ SpStringTableColumn new
			title: 'Value'; 
			displayBold: [ :each | self boldFor: each ];
			displayColor: [ :each | self colorFor: each ];
			evaluated: [ :each | each content ];
			onTextChanged: [ :each :value | self content: value for: each ];
			onAcceptEdition: [ table refresh ];
			yourself
]

{ #category : 'coloring' }
LDAPAttributePresenter >> defaultColor [

	^ (SHRBTextStyler attributesFor: #default) ifEmpty: [ self theme textColor ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'private - accessing' }
LDAPAttributePresenter >> description: aString for: anAttribute [

	anAttribute description: aString.

]

{ #category : 'initialization' }
LDAPAttributePresenter >> descriptionColumn [ 
	
	^ SpStringTableColumn new
			title: 'Attribute';
			displayBold: [ :each | self boldFor: each ];
			displayColor: [ :each | self colorFor: each ];
			evaluated: [ :each | each description ];
			onTextChanged: [ :each :value | self description: value for: each ];
			onAcceptEdition: [ table refresh ];
			yourself
]

{ #category : 'coloring' }
LDAPAttributePresenter >> errorColor [

	^ (SHRBTextStyler attributesFor: #invalid) ifEmpty: [ Color red ]
		ifNotEmpty: [ :a | a first color ]
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> filledAttributes [
	
	^ self attributes select: [ :element | element isValid ]
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

	parentLabel := self newLabel label: 'Parent DN: '.
	parent := self newTextInput beNotEditable.
	help := self newText beNotEditable; beWrapWord; withoutScrollBars;
		text: 'Check the attributes to be used as relative distinguished name'.
	toolbar := self newToolbar beIcons;
		add: (self newToolbarButton label: 'add';
				  			icon: (self iconNamed: #smallAdd);
				     		help: 'Add a new attribute line';
				       	action: [ self addNewElement ];
				        	yourself); yourself.

	table := self newTable isResizable: true; yourself.
]

{ #category : 'accessing' }
LDAPAttributePresenter >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModel: aCollection [

	self attributes: aCollection
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModelBeforeInitialization: aCollection [

	attributes := aCollection

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
 
	table items: self attributes
]
