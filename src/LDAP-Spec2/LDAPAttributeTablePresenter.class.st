"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributeTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parent',
		'table',
		'lines',
		'customAttributeType',
		'parentLabel',
		'schema'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'accessing' }
LDAPAttributeTablePresenter class >> currentApplication [ 
	^ LDAPEditor new
]

{ #category : 'ui building' }
LDAPAttributeTablePresenter >> actionsColumns [

	^ { self buttonColumn bind: [ :aPresenter :anAttribute | anAttribute configButton: aPresenter for: self ]
		.self buttonColumn bind: [ :aPresenter :anAttribute | anAttribute addButton: aPresenter for: self ]
		.self buttonColumn bind: [ :aPresenter :anAttribute | anAttribute deleteButton: aPresenter for: self ]
		}
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> addActionOn: aLine [

	| index attribute |
	index := lines identityIndexOf: aLine.
	attribute := self newLineFrom: aLine.
	lines add: attribute afterIndex: index.
	self allowDeleteOn: aLine.
	self updatePresenter
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> addCustomAttribute: aString [ 

	| attribute |
	customAttributeType := aString.
	attribute := LDAPCustomAttributeTableLine new description: aString; content: ''; yourself.
	lines add: attribute beforeIndex: lines size.
	self updateAttributes 
]

{ #category : 'private - updating' }
LDAPAttributeTablePresenter >> allowDeleteOn: aLine [

	aLine isSpecial ifTrue: [ ^self ].
	aLine canBeDeleted: true; updatePresenters
]

{ #category : 'converting' }
LDAPAttributeTablePresenter >> asAttributes [

	| valid |
	valid := lines select: #isValid.
	^ valid collect: #entryAttribute
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

{ #category : 'private - updating' }
LDAPAttributeTablePresenter >> blockDeleteOn: aLine [

	aLine isSpecial ifTrue: [ ^self ].
	aLine canBeDeleted: false; updatePresenters
]

{ #category : 'private - updating' }
LDAPAttributeTablePresenter >> buildLinesFrom: aCollection [

	| sorter |
	sorter := LDAPAttributeLineSorter new schema: self schema; attributes: aCollection.
	lines := sorter lines.
]

{ #category : 'ui building' }
LDAPAttributeTablePresenter >> buttonColumn [

	^ SpColumnViewColumn new
			width: 28;
			setup: [ :aPresenter | aPresenter newPresenter layout: SpBoxLayout newLeftToRight; yourself ];
			yourself
]

{ #category : 'testing' }
LDAPAttributeTablePresenter >> checkOkTrigger [
"Check all required attributes have a content"
	| required |
	required := lines select: #isRequired.
	required detect: [ :element | element content isEmpty ]
		ifFound: [ :element | self inform: 'Required Attribute ''', element description, ''' has no value'. ^ false ].

	^ true
]

{ #category : 'private' }
LDAPAttributeTablePresenter >> colorFor: anAttribute [

	(anAttribute isRequired and: [ anAttribute isValid not ]) ifTrue: [ ^ application errorColor ].
	anAttribute isKnown ifFalse: [ ^ application disabledColor ].
	anAttribute isKey ifTrue: [ ^ application emphasisColor ].
	^ application defaultColor
]

{ #category : 'ui building' }
LDAPAttributeTablePresenter >> contentColumn [

	^ SpColumnViewColumn new
			title: 'Values';
			beExpandable;
			setup: [ :aPresenter | | presenter |
				(presenter := aPresenter newPresenter)
					layout: SpBoxLayout newLeftToRight;
					yourself
			];
			bind: [ :aPresenter :anAttribute |
				anAttribute addContentPresenter: aPresenter
			];
			yourself
]

{ #category : 'accessing' }
LDAPAttributeTablePresenter >> customAttributeType [

	^ customAttributeType ifNil: ['']
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> deleteActionOn: aLine [

	(self shouldRemove: aLine)
		ifTrue: [| index |
			index := lines identityIndexOf: aLine.
			lines removeAt: index.
		] 
		ifFalse: [ 
			aLine content: ''.
			self blockDeleteOn: aLine.
		].
	self updatePresenter
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> deleteObjectClassActionOn: aLine [

	| index |
	index := lines identityIndexOf: aLine.
	lines removeAt: index.
	"We need to remove attributes no more needed"
	lines := lines reject: [ :each | each content isEmpty ].
	self updateAttributes
]

{ #category : 'ui building' }
LDAPAttributeTablePresenter >> descriptionColumn [ 
	
	^ SpColumnViewColumn new 
			title: 'Attribute'; 
			beExpandable;
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
				aPresenter layout children first 
					image: (self iconFor: anAttribute);
					help: (self iconTipFor: anAttribute).
				aPresenter layout children second 
					label: anAttribute description;
					displayColor: [ self colorFor: anAttribute ];
					displayBold: [ anAttribute bold ]
				];
			yourself
]

{ #category : 'private' }
LDAPAttributeTablePresenter >> iconFor: anAttribute [

	self subclassResponsibility.
	^ self iconNamed: #blank
]

{ #category : 'private' }
LDAPAttributeTablePresenter >> iconTipFor: anAttribute [

	^ anAttribute help
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
	table := self newColumnView isResizable: true; yourself.
]

{ #category : 'accessing' }
LDAPAttributeTablePresenter >> name [

	^ self subclassResponsibility
]

{ #category : 'private' }
LDAPAttributeTablePresenter >> newLineFrom: aLine [

	^ aLine copy
]

{ #category : 'accessing' }
LDAPAttributeTablePresenter >> numberOfLines [

	^ lines ifNotNil: [ lines size ] ifNil: [ 0 ]
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> promptCustomAttribute [

	SpRequestDialog new
		title: 'Add Custom Attribute';
		label: 'Enter the name of the new attribute';
		text: self customAttributeType;
		acceptLabel: 'Add';
		cancelLabel: 'Cancel';
		validateAnswer: [ :text | text isNotEmpty ];
		onAccept: [ :dialog | self addCustomAttribute: dialog presenter text ];
		openDialog
]

{ #category : 'accessing' }
LDAPAttributeTablePresenter >> schema [

	^ application schema
]

{ #category : 'events' }
LDAPAttributeTablePresenter >> selectObjectClass: aLine [

	| presenter |
	presenter := LDAPObjectClassChooserPresenter newApplication: application model: self schema structuralClasses.

	presenter selectItem: aLine content.

	^ presenter openDialog 
		okAction: [ :dialog | | selection |
			selection := dialog presenter selectedItem.
			aLine objectClass: selection.
			self updateAttributes
		];
		cancelAction: [ :dialog | dialog inform: 'Cancelled Object Classes selection' ];
		yourself.
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> setModel: aCollection [

	self setModelBeforeInitialization: aCollection.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPAttributeTablePresenter >> setModelBeforeInitialization: aCollection [

	self buildLinesFrom: aCollection
]

{ #category : 'private - updating' }
LDAPAttributeTablePresenter >> shouldRemove: aLine [

	| count |
	aLine isKnown ifFalse: [ ^ true ].
	count := lines count: [ :line | line description sameAs: aLine description ].
	^ count > 1
]

{ #category : 'private - updating' }
LDAPAttributeTablePresenter >> updateAttributes [ 

	| attributes keep |
	"Remove special and known attributes not valid to avoid clutter"
	keep := lines select: [ :line | line isValid or: [ (line isSpecial | line isKnown) not ] ].
	attributes := keep collect: #entryAttribute.
	self buildLinesFrom: attributes.
	self updatePresenter
]

{ #category : 'initialization' }
LDAPAttributeTablePresenter >> updatePresenter [
 
	table items: lines
]
