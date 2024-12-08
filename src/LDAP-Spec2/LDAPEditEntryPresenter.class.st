"
I am the presenter opened for editing attributes in an entry.
"
Class {
	#name : 'LDAPEditEntryPresenter',
	#superclass : 'LDAPAttributePresenter',
	#instVars : [
		'name',
		'rdn'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

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

{ #category : 'private' }
LDAPEditEntryPresenter >> colorFor: anAttribute [

	^ self defaultColor 
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

{ #category : 'initialization' }
LDAPEditEntryPresenter >> initializePresenters [ 

	super initializePresenters.
	
	help text: 'Check the attributes to be deleted'.
	rdn := self newTable hideColumnHeaders; withoutScrollBars; propagateNaturalHeight: true;
		isResizable: true;
		addColumn: self descriptionColumn;
		addColumn: self contentColumn;
		yourself.
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

	| name request |
	name := self name.
	
	request := LDAPModifyRequest new name: name.
	
	^ request
]

{ #category : 'accessing' }
LDAPEditEntryPresenter >> name [

	^ name ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPEditEntryPresenter >> name: aString [
	
	| |
	name := aString.
	parent text: (LDAPName parentOf: aString).
	self updatePresenter.
]

{ #category : 'initialization' }
LDAPEditEntryPresenter >> updatePresenter [
 
	| rdnAttributes otherAttributes |
	rdnAttributes := (LDAPName firstAsPairs: self name) collect: [ :pair | LDAPLeafEntryAttribute newFromPair: pair ].
	otherAttributes := self attributes difference: rdnAttributes.
	rdn items: rdnAttributes.
	table items: otherAttributes.
]
