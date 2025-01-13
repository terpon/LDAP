"
I am the presenter to modify an entry RDN
"
Class {
	#name : 'LDAPModifyEntryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'name',
		'parentLabel',
		'parent',
		'table',
		'dropRDN',
		'underLabel',
		'underDN'
	],
	#category : 'LDAP-Spec2-Entries',
	#package : 'LDAP-Spec2',
	#tag : 'Entries'
}

{ #category : 'examples' }
LDAPModifyEntryPresenter class >> example [
	| aPresenter aDialog |
	aPresenter := self on: 'cn=föô,dc=example,dc=com'.
	aDialog := aPresenter openDialog 
		okAction: [ :dialog | dialog presenter modifyRequest inspect ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
	^ aPresenter

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

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter title: 'Modify Entry DN'
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
	^ name
]

{ #category : 'accessing' }
LDAPModifyEntryPresenter >> newRelativeName [

	^ String streamContents: [ :out |
		(table items select: #isValid)
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
	]
]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> setModel: aString [

	self setModelBeforeInitialization: aString.
	self updatePresenter.
]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> setModelBeforeInitialization: aString [

	name := aString.

]

{ #category : 'initialization' }
LDAPModifyEntryPresenter >> updatePresenter [
 
	| aDN elements parentDN |
	aDN := name ifNil: [ '' ] .
	parentDN := (LDAPName parentOf: aDN).
	parent text: parentDN.

	elements := LDAPLeafEntryAttribute arrayFromRelativeNameIn: aDN.
	table items: elements
]
