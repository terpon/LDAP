"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributeTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parent',
		'table',
		'attributes',
		'help',
		'parentLabel',
		'toolbar'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'accessing' }
LDAPAttributeTablePresenter class >> currentApplication [ 
	^ LDAPBrowser new
]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> actionsColumn [

	^ SpColumnViewColumn new
			title: 'Actions';
			width: 60;
			setup: [ :aPresenter | | presenter |
				(presenter := aPresenter newPresenter)
					layout: SpBoxLayout newHorizontal hAlignCenter;
					yourself ];
			bind: [ :aPresenter :anAttribute |
				anAttribute addActions: aPresenter
			];
			yourself
]

{ #category : 'adding' }
LDAPAttributeTablePresenter >> addNewElement [

	self subclassResponsibility.
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> attributes [
	
	^ attributes ifNil: [ attributes := #() ]
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> attributes: aCollection [
	
	attributes := aCollection.
	self updatePresenter
]

{ #category : 'helper' }
LDAPAttributeTablePresenter >> attributesAsDictionary: aCollection [
	
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
LDAPAttributeTablePresenter >> boldFor: anAttribute [

	self subclassResponsibility.	
	^ false 
]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> checkColumn [ 

	^ SpCheckBoxTableColumn new
			beNotExpandable; width: 20;
			onActivation: [ :each | self checkStateChanged: true for: each ];
			onDeactivation: [ :each | self checkStateChanged: false for: each ];
			evaluated: [ :each | self checkStateFor: each ];
			yourself
]

{ #category : 'testing' }
LDAPAttributeTablePresenter >> checkOkTrigger [

	self subclassResponsibility.
	^ true
]

{ #category : 'private - accessing' }
LDAPAttributeTablePresenter >> checkStateChanged: aBoolean for: anAttribute [

	self subclassResponsibility.
]

{ #category : 'private - accessing' }
LDAPAttributeTablePresenter >> checkStateFor: anAttribute [

	self subclassResponsibility.
	^ false
]

{ #category : 'private' }
LDAPAttributeTablePresenter >> colorFor: anAttribute [

	self subclassResponsibility.	
	^ application defaultColor 
]

{ #category : 'private - accessing' }
LDAPAttributeTablePresenter >> content: aString for: anAttribute [

	anAttribute content: aString.

]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> contentColumn [

	^ SpColumnViewColumn new
			title: 'Values';
			setup: [ :aPresenter | | presenter |
				(presenter := aPresenter newPresenter
					layout: SpBoxLayout newHorizontal hAlignCenter)
					yourself ];
			bind: [ :aPresenter :anAttribute |
				anAttribute addContentPresenter: aPresenter
			];
			yourself
]

{ #category : 'private - accessing' }
LDAPAttributeTablePresenter >> description: aString for: anAttribute [

	anAttribute description: aString.

]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> descriptionColumn [ 
	
	^ SpColumnViewColumn new 
			title: 'Attribute'; 
			setup: [ :aPresenter |
				| presenter |
				(presenter := aPresenter newPresenter)
					layout: (SpBoxLayout newHorizontal
						spacing: 3;
						add: presenter newImage expand: false;
						add: presenter newLabel;
						yourself);
					yourself ];
			bind: [ :aPresenter :anAttribute | 
				| image label |
				image := aPresenter layout children first.
				image image: anAttribute icon.
				label := aPresenter layout children second.
				label label: anAttribute description ];
			yourself
]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> initializeDialogWindow: aDialogWindowPresenter [
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
LDAPAttributeTablePresenter >> initializePresenters [ 

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
LDAPAttributeTablePresenter >> name [

	^ self subclassResponsibility
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> setModel: aCollection [

	self attributes: aCollection
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> setModelBeforeInitialization: aCollection [

	attributes := aCollection

]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> updatePresenter [
 
	table items: self attributes
]
