"
I am the presenter opened when a new entry is created. Attributes for that entry are filled here.
"
Class {
	#name : 'LDAPNewEntryPresenter',
	#superclass : 'LDAPAttributeTablePresenter',
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

{ #category : 'adding' }
LDAPNewEntryPresenter >> addNewElement [

	attributes := self attributes copyWith: LDAPLeafEntryAttribute new.
	self updatePresenter.
]

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

	^ anAttribute isKey
]

{ #category : 'testing' }
LDAPNewEntryPresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| bag |
	table refresh.
	bag := self attributes reject: #isEmpty.

	bag detect: [ :element | element isKey and: [ element content isEmpty] ]
		ifFound: [ :element | self inform: 'Attribute ''', element description, ''' for RDN has no value'. ^ false ].
	
	"Ignore attributes with no content"	
	bag := bag reject: [ :element | element content isEmpty ].
	bag detect: [ :element | element description isEmpty ]
		ifFound: [ :element | self inform: 'Attribute value ''', element content, ''' has no name'. ^ false ].
		
	bag := bag select: #isKey.
	bag ifEmpty: [ self inform: 'No attributes selected for Relative Distinguished Name'. ^ false ].
	
	bag := bag asBag collect: #description.
	bag associationsDo: [ :a | a value > 1 
		ifTrue: [ self inform: 'Multiple attributes with type ''', a key, ''' used for RDN'. ^ false ] ].
	^ true
]

{ #category : 'private - accessing' }
LDAPNewEntryPresenter >> checkStateChanged: aBoolean for: anAttribute [

	| index class |
	aBoolean = anAttribute isKey ifTrue: [ ^self ].
	
	index := table items identityIndexOf: anAttribute ifAbsent: [ self inform: 'no such attribute ', anAttribute asString. ^ self ].
	
	class := aBoolean ifFalse: [ LDAPLeafEntryAttribute ] ifTrue: [ LDAPKeyEntryAttribute ]. 
	table items at: index put: (class copy: anAttribute).
	table refresh.
]

{ #category : 'private - accessing' }
LDAPNewEntryPresenter >> checkStateFor: anAttribute [

	^ anAttribute isKey
]

{ #category : 'private' }
LDAPNewEntryPresenter >> colorFor: anAttribute [

	(anAttribute description isEmpty and: [ anAttribute content isNotEmpty ]) ifTrue: [ ^ application errorColor ].
	
	anAttribute isKey ifFalse: [ ^ application defaultColor ].
	
	anAttribute content isEmpty ifTrue: [ ^ application errorColor ].

	((self attributes count: [ :a | a isKey and: [a description = anAttribute description] ]) > 1) ifTrue: [ ^ application errorColor ].
	
	^ application emphasisColor
	
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

{ #category : 'accessing - model' }
LDAPNewEntryPresenter >> filledAttributes [
	
	^ self attributes select: [ :element | element isValid ]
]

{ #category : 'initialization' }
LDAPNewEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	help text: 'Check the attributes to be used as relative distinguished name'.
	
	table 
		addColumn: self checkColumn;
		addColumn: self descriptionColumn;
		addColumn: self contentColumn.

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
		(self attributes select: [ :element | element isValid and: [ element isKey ] ])
			do: [ :element | out nextPutAll: element description; nextPut: $=; nextPutAll: element content ] 
			separatedBy: [ out nextPut: $+ ].
		parent text ifNotEmpty: [ :string | out nextPut: $,; nextPutAll: string ]
	]
]

{ #category : 'accessing' }
LDAPNewEntryPresenter >> parent: aString [

	parent text: aString 
]
