"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'parent',
		'rdn',
		'table',
		'checks',
		'text',
		'attributes',
		'help',
		'parentLabel'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPAttributePresenter class >> example [
	| aModel |
	aModel := self sampleElement.
	^ (self on: aModel) openDialog

]

{ #category : 'examples' }
LDAPAttributePresenter class >> sampleElement [
"Sample search result"
	| entry list |
	entry := LDAPSearchResultEntry new.
	entry addElement: (LDAPString new content: 'cn=foo,dc=example,dc=com').
	list := LDAPPartialAttributeList new addAll: { 
				LDAPPartialAttribute new description: 'objectClass'; values: 'person'; yourself.
				LDAPPartialAttribute new description: 'cn'; values: 'foo'; yourself.
				LDAPPartialAttribute new description: 'sn'; values: { 'bar'. 'nox' }; yourself 
			 }; yourself.
	entry addElement: list.
	^ entry flattened 

]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> attributes: aCollectionOfPairs [
	
	| extraLine |
	extraLine := aCollectionOfPairs copyWith: #( '' '' ).
	attributes := extraLine withIndexCollect: [ :each :index | | element |
		element := LDAPAttributeElement new index: index;
			description: each first;
			content: each second.
		element state: (self stateFor: element)
	]

]

{ #category : 'testing' }
LDAPAttributePresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| bag |
	"Ignore attributes with no content"	
	bag := attributes reject: [ :element | element content isEmpty ].
	bag detect: [ :element | element description isEmpty ]
		ifFound: [ :element | self inform: 'Attribute value ''', element content, ''' has no name'. ^ false ].
		
	bag := bag select: #state.
	bag ifEmpty: [ self inform: 'No attribute selected for Relative Distinguished Name'. ^ false ].
	
	bag := bag collect: [ :element | element description ].
	bag asBag associationsDo: [ :a | a value > 1 
		ifTrue: [ self inform: 'Multiple attributes with type ''', a key, ''' used for RDN'. ^false ] ].
	^ true
]

{ #category : 'layout' }
LDAPAttributePresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: table;
		add: help expand: false;
		yourself
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

	parentLabel := self newLabel label: 'Parent DN'.
	parent := self newTextInput beNotEditable.
	help := self newText beNotEditable; beWrapWord; withoutScrollBars;
		text: 'Check the attributes to be used as relative distinguished name'.
	checks := SpCheckBoxTableColumn new
			beNotExpandable; width: 20;
			onActivation: [ :each | each state: true. table refresh ];
			onDeactivation: [ :each | each state: false. table refresh ];
			evaluated: [ :each | each state ].
	table := self newTable
		isResizable: true;
		addColumn: checks;
		addColumn: (SpStringTableColumn new
			title: 'Attribute';
			beEditable;
			displayBold: [ :each | each state ];
			evaluated: [ :each | each description ];
			onTextChanged: [ :each :value | each description: value ];
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Value'; 
			beEditable;
			displayBold: [ :each | each state ];
			evaluated: [ :each | each content ];
			onTextChanged: [ :each :value | each content: value ];
			yourself);
	yourself.
]

{ #category : 'initialization' }
LDAPAttributePresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter title: 'Attributes for a new entry'.
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

{ #category : 'testing' }
LDAPAttributePresenter >> stateFor: anElement [

	rdn ifNil: [ ^false ].
	^ rdn includes: anElement name
]

{ #category : 'initialization' }
LDAPAttributePresenter >> updatePresenter [
 
	table items: attributes
]
