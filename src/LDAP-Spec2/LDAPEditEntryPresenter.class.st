"
I am the presenter opened for editing attributes in an entry.
"
Class {
	#name : 'LDAPEditEntryPresenter',
	#superclass : 'LDAPAttributeTablePresenter',
	#instVars : [
		'name',
		'rdn',
		'clear',
		'checked'
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
	}.
	aPresenter := self on: aModel.
	aPresenter name: 'cn=foo,dc=example,dc=com'.
	aDialog := aPresenter openDialog 
		okAction: [ :dialog | dialog presenter modifyRequest inspect ];
		cancelAction: [ :dialog | dialog inform: 'Cancelled' ];
		yourself.
	^ aPresenter

]

{ #category : 'adding' }
LDAPEditEntryPresenter >> addNewElement [

	table items: (table items copyWith: LDAPLeafEntryAttribute new).
	checked := checked copyWith: false.
]

{ #category : 'private' }
LDAPEditEntryPresenter >> boldFor: anAttribute [

	^ false
]

{ #category : 'testing' }
LDAPEditEntryPresenter >> checkOkTrigger [
"At least one attribute must be checked and to two identical descriptions"
	| bag |
	table refresh.

	"Ignore attributes with no content"	
	bag := self attributes reject: [ :element | element content isEmpty ].
	bag detect: [ :element | element description isEmpty ]
		ifFound: [ :element | self inform: 'Attribute value ''', element content, ''' has no name'. ^ false ].
		
	^ true
]

{ #category : 'private - accessing' }
LDAPEditEntryPresenter >> checkStateChanged: aBoolean for: anAttribute [

	| index |
	index := table items identityIndexOf: anAttribute ifAbsent: [ self inform: 'no such attribute ', anAttribute asString. ^ self ].
	checked at: index put: aBoolean.
	
	aBoolean ifTrue: [ clear enable ] 
		ifFalse: [ clear enabled: (checked anySatisfy: [ :each | each ]) ].
	
	
]

{ #category : 'private - accessing' }
LDAPEditEntryPresenter >> checkStateFor: anAttribute [

	| index |
	index := table items identityIndexOf: anAttribute ifAbsent: [ ^false ].
	^ checked at: index
]

{ #category : 'private' }
LDAPEditEntryPresenter >> colorFor: anAttribute [

	| index |
	(rdn items identityIncludes: anAttribute) ifTrue: [ ^ application emphasisColor ].
	
	index := table items identityIndexOf: anAttribute ifAbsent: [ ^ application errorColor ].
	(checked at: index) ifTrue: [ ^ application disabledColor ].
	
	^ application defaultColor 
]

{ #category : 'layout' }
LDAPEditEntryPresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: (SpBoxLayout newLeftToRight vAlignCenter;
			add: parentLabel expand: false; 
			add: parent; 
			yourself) expand: false;
		add: rdn expand: false;
		add: table expand: true;
		add: toolbar expand: false;
		add: help expand: false;
		yourself
]

{ #category : 'callbacks' }
LDAPEditEntryPresenter >> deleteSelectedElements [

	| attrs |
	clear isEnabled ifFalse: [ ^self ].
	attrs := table items withIndexSelect: [ :element :index | (checked at: index) not ].
	checked := Array new: attrs size withAll: false.
	table items: attrs.

]

{ #category : 'initialization' }
LDAPEditEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	help text: 'Check the attributes to enable the delete button'.
	rdn := self newTable hideColumnHeaders; withoutScrollBars; propagateNaturalHeight: true;
		isResizable: true;
		addColumn: self descriptionColumn;
		addColumn: self contentColumn;
		yourself.
	
	table 
		addColumn: self descriptionColumn beEditable;
		addColumn: self contentColumn beEditable;
		addColumn: self checkColumn.

	clear := self newToolbarButton disable;
		label: 'clear';
		icon: (self iconNamed: #smallCancel);
		help: 'Delete selected attributes';
	   	action: [ self deleteSelectedElements ];
	   	yourself.
	toolbar add: clear.

]

{ #category : 'initialization' }
LDAPEditEntryPresenter >> initializeWindow: aWindowPresenter [
	
	| height |
	super initializeWindow: aWindowPresenter.
	
	height := self attributes size min: 20 max: 8.
	height := StandardFonts defaultFont lineGrid * (height + 10) * 1.5.
	
	aWindowPresenter 
		title: 'Edit Attributes';
		initialExtent: 400 @ height
]

{ #category : 'accessing - model' }
LDAPEditEntryPresenter >> modifyRequest [

	| oldAttrs newAttrs request oldDescriptions newDescriptions addedAttributes |
	request := LDAPModifyRequest new name: self name.
	oldAttrs := self attributesAsDictionary: self attributes.
	newAttrs := self attributesAsDictionary: (rdn items, (table items select: [:i | i isValid])).
	
	oldDescriptions := oldAttrs keys.
	newDescriptions := newAttrs keys.
	
	(oldDescriptions difference: newDescriptions) do: [:description | 
		request delete: description
	].
	(addedAttributes := newDescriptions difference: oldDescriptions) do: [ :description |
		request description: description add: (newAttrs at: description) 
	].
	(newDescriptions difference: addedAttributes) reject: [ :description |
		(oldAttrs at: description) = (newAttrs at: description) 		
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

{ #category : 'initialization' }
LDAPEditEntryPresenter >> updatePresenter [
 
	| rdnAttributes otherAttributes |
	rdnAttributes := self attributes select: #isKey.
	rdn items: rdnAttributes.

	"Pass a copy of the attributes, we want to compare them for creating the request"
	otherAttributes := (self attributes difference: rdnAttributes) collect: #copy.
	checked := Array new: otherAttributes size withAll: false.
	table items: otherAttributes.
]
