Class {
	#name : 'LDAPGenericAttributeTableLine',
	#superclass : 'LDAPAbstractAttributeTableLine',
	#instVars : [
		'description',
		'content',
		'isKey',
		'canBeDeleted',
		'canBeModified'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'instance creation' }
LDAPGenericAttributeTableLine class >> empty: anAttributeType [

	^ self new 
		description: anAttributeType name;
		content: '';
		yourself
]

{ #category : 'ui building' }
LDAPGenericAttributeTableLine >> addButton: aPresenter for: aDialog [
	
	addButton := (self newAddButton: aPresenter)
				action: [ aDialog addActionOn: self ];
				yourself.
	
	self setButton: addButton in: aPresenter
]

{ #category : 'adding' }
LDAPGenericAttributeTableLine >> addContentPresenter: aPresenter [

	contentPresenter := aPresenter newTextInput text: self content;
		editable: self canBeModified;
		whenTextChangedDo: [ :t | self content: t ].
	aPresenter layout add: contentPresenter expand: true.
	^ self
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> attribute: anObject [

	description := anObject description.
	content := anObject content.
	isKey := anObject isKey.
	self updatePresenters
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> beProtected [ 

	self canBeDeleted: false.
	self canBeModified: false.
	^ self
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canBeDeleted [

	^ (canBeDeleted ifNil: [ true ]) and: [ self isValid ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canBeDeleted: anObject [

	canBeDeleted := anObject.
	self updatePresenters.
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canBeModified [

	^ canBeModified ifNil: [ true ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canBeModified: aBoolean [

	canBeModified := aBoolean.
	self updatePresenters.
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> content [ 

	^ content ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> content: anObject [

	content := anObject.
	self updatePresenters
]

{ #category : 'ui building' }
LDAPGenericAttributeTableLine >> deleteButton: aPresenter for: aDialog [
	
	deleteButton := (self newDeleteButton: aPresenter)
				enabled: self canBeDeleted;
				action: [ aDialog deleteActionOn: self ];
				yourself.

	 self setButton: deleteButton in: aPresenter
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> description [ 

	^ description ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> description: anObject [

	description := anObject.
	self updatePresenters
]

{ #category : 'converting' }
LDAPGenericAttributeTableLine >> entryAttributeClass [
	
	self isKey ifTrue: [ ^ LDAPKeyEntryAttribute ].

	^ super entryAttributeClass
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> help [

	^ 'Abstract Attribute'
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> icon [ 

	self isKey ifTrue: [ ^ self iconNamed: #announcement ].
	
	^ super icon
	

]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> isKey [

	^ isKey ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> isKey: anObject [

	isKey := anObject.
	self updatePresenters
]

{ #category : 'testing' }
LDAPGenericAttributeTableLine >> isSpecial [

	^ false
]

{ #category : 'testing' }
LDAPGenericAttributeTableLine >> isValid [

	^ self content isNotEmpty
]

{ #category : 'ui building' }
LDAPGenericAttributeTableLine >> keyCheckbox: aPresenter for: aDialog [
	
	| check |
	check := aPresenter newCheckBox 
				addStyle: 'compact';
				state: self isKey;
				whenChangedDo: [ :p | self isKey: p ];
				yourself.
	aPresenter layout add: check expand: false
]

{ #category : 'testing' }
LDAPGenericAttributeTableLine >> sameTypeAs: anObject [

	^ self description sameAs: anObject description
]

{ #category : 'updating - presenters' }
LDAPGenericAttributeTableLine >> updatePresenters [

	addButton ifNotNil: [ :button | button enabled: self isValid ].
	deleteButton ifNotNil: [ :button | button enabled: self canBeDeleted ].
	contentPresenter ifNotNil: [ :presenter | presenter editable: self canBeModified ].
]
