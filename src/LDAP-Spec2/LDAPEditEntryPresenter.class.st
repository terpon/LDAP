"
I am the presenter opened for editing attributes in an entry.
"
Class {
	#name : 'LDAPEditEntryPresenter',
	#superclass : 'LDAPAttributeTablePresenter',
	#instVars : [
		'name',
		'startAttributes'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'examples' }
LDAPEditEntryPresenter class >> example [
	| aModel aPresenter aDialog |
	aModel := {
		LDAPLeafEntryAttribute newFromPair: #( 'objectClass' 'person' ).
		LDAPKeyEntryAttribute newFromPair: #( 'cn' 'foo' ).
		LDAPLeafEntryAttribute newFromPair: #( 'sn' 'bar' ).
		LDAPLeafEntryAttribute newFromPair: #( 'sn' 'nox' ).
		LDAPLeafEntryAttribute newFromPair: #( 'description' 'line 1' ).
		LDAPLeafEntryAttribute newFromPair: #( 'description' 'line 2' ).
		LDAPLeafEntryAttribute newFromPair: #( 'description' 'line 3' ).
	}.
	aPresenter := self on: aModel.
	aPresenter name: 'cn=foo,dc=example,dc=com'.
	aDialog := aPresenter openDialog 
		okAction: [ :dialog | dialog presenter modifyRequest inspect ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
	^ aPresenter

]

{ #category : 'private - updating' }
LDAPEditEntryPresenter >> allowDeleteOn: aLine [

	aLine isKey ifTrue: [ ^self ].
	^ super allowDeleteOn: aLine
]

{ #category : 'private - updating' }
LDAPEditEntryPresenter >> buildLinesFrom: aCollection [

	super buildLinesFrom: aCollection.
	lines select: #isKey thenDo: [ :line | line beProtected ].
]

{ #category : 'layout' }
LDAPEditEntryPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: table expand: true;
		yourself
]

{ #category : 'private' }
LDAPEditEntryPresenter >> iconFor: anAttribute [

	^ anAttribute icon
]

{ #category : 'initialization' }
LDAPEditEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	table 
		addColumn: self descriptionColumn;
		addColumn: self contentColumn;
		addColumns: self actionsColumns.
]

{ #category : 'initialization' }
LDAPEditEntryPresenter >> initializeWindow: aWindowPresenter [
	
	| height |
	super initializeWindow: aWindowPresenter.
	
	height := self numberOfLines min: 20 max: 8.
	height := StandardFonts defaultFont lineGrid * (height + 10) * 1.5.
	
	aWindowPresenter 
		title: 'Edit Attributes';
		initialExtent: 420 @ height
]

{ #category : 'accessing - model' }
LDAPEditEntryPresenter >> modifyRequest [

	| newAttrs request oldDescriptions newDescriptions addedAttributes |
	request := LDAPModifyRequest new name: self name.
	newAttrs := self attributesAsDictionary: self asAttributes.
	
	oldDescriptions := startAttributes keys.
	newDescriptions := newAttrs keys.
	
	(oldDescriptions difference: newDescriptions) do: [:description | 
		request delete: description
	].
	(addedAttributes := newDescriptions difference: oldDescriptions) do: [ :description |
		request description: description add: (newAttrs at: description) 
	].
	(newDescriptions difference: addedAttributes) reject: [ :description |
		(startAttributes at: description) = (newAttrs at: description) 		
	] thenDo: [:description | 
		request set: description to: (newAttrs at: description) 
	].

	^ request
]

{ #category : 'accessing' }
LDAPEditEntryPresenter >> name [

	^ name ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPEditEntryPresenter >> name: aString [
	
	name := aString.
	parent text: (LDAPName parentOf: aString).
	self updatePresenter.
]

{ #category : 'private' }
LDAPEditEntryPresenter >> newLineFrom: aLine [

	| line |
	"A copy should be editable, so create a new line"
	line := aLine isSpecial
				ifFalse: [ aLine class new description: aLine description; content: aLine content; yourself ]
				ifTrue: [ aLine copy ].

	^ line
]

{ #category : 'accessing - model' }
LDAPEditEntryPresenter >> setModelBeforeInitialization: aCollection [

	startAttributes := self attributesAsDictionary: aCollection.
	super setModelBeforeInitialization: aCollection.
]
