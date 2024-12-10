"
I am the presenter to modify an entry RDN
"
Class {
	#name : 'LDAPModifyEntryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'attributes',
		'parent',
		'table',
		'dropRDN',
		'underDN',
		'parentLabel',
		'underLabel'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPModifyEntryPresenter class >> example [
	| aModel aPresenter aDialog |
	aModel := {
		LDAPLeafEntryAttribute newFromPair: #( 'cn' 'föô' ).
	}.
	aPresenter := self on: aModel.
	aPresenter parent: 'dc=example,dc=com'.
	aDialog := aPresenter openDialog 
		okAction: [ :dialog | dialog presenter modifyRequest inspect ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
	^ aPresenter

]

{ #category : 'accessing' }
LDAPModifyEntryPresenter >> attributes [
	^ attributes ifNil: [ #() ]
]

{ #category : 'layout' }
LDAPModifyEntryPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: table expand: true;
		add: dropRDN expand: false;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: underLabel expand: false; 
			add: underDN; 
			yourself) expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> initializePresenters [ 

	parentLabel := self newLabel label: 'Parent DN: '.
	parent := self newTextInput beNotEditable.
	underLabel := self newLabel label: 'Move under DN: '.
	underDN := self newTextInput.
	dropRDN := self newCheckBox label: 'Drop existing RDN in the new entry'.
	table := self newTable isResizable: true; 
		addColumn: (SpStringTableColumn new
			title: 'Attribute';
			evaluated: [ :each | each description ];
			yourself);
		addColumn: (SpStringTableColumn new beEditable;
			title: 'Value';
			evaluated: [ :each | each content ];
			onTextChanged: [ :each :value | each content: value ];
			yourself);
		yourself.
]

{ #category : 'converting' }
LDAPModifyEntryPresenter >> modifyRequest [
	| request |
	request := LDAPModifyNameRequest new
		name: self name;
		newRelativeName: self newRelativeName;
		shouldDeleteOldRelativeName: dropRDN state;
		yourself.
	underDN text ifNotEmpty: [ :newParent | request underName: newParent ].
	^ request
]

{ #category : 'accessing' }
LDAPModifyEntryPresenter >> name [
	"return the original name"
	^ String streamContents: [ :out |
		attributes 
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
		parent text ifNotEmpty: [ :string | out nextPut: $,; nextPutAll: string ]
	]
]

{ #category : 'accessing' }
LDAPModifyEntryPresenter >> newRelativeName [

	^ String streamContents: [ :out |
		(table items select: #isValid)
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
	]
]

{ #category : 'accessing' }
LDAPModifyEntryPresenter >> parent: aString [ 
	parent text: aString
]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> setModel: aCollection [

	attributes := aCollection.
	self updatePresenter.
]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> setModelBeforeInitialization: aCollection [

	attributes := aCollection

]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> updatePresenter [
 
	table items: (self attributes collect: #copy)
]
