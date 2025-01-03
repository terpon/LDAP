Class {
	#name : 'LDAPGenericAttributeTableLine',
	#superclass : 'LDAPEmptyAttributeTableLine',
	#instVars : [
		'description',
		'content',
		'canDelete',
		'isKey'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'instance creation' }
LDAPGenericAttributeTableLine class >> empty: anAttributeType [

	^ self new 
		beNotDeletable;
		description: anAttributeType name;
		content: '';
		yourself
]

{ #category : 'adding' }
LDAPGenericAttributeTableLine >> addActions: aPresenter for: aDialog [
	
	addButton := (self newAddButton: aPresenter)
				action: [ aDialog addActionOn: self ];
				yourself.
	
	deleteButton := (self newDeleteButton: aPresenter)
				enabled: self canDelete;
				action: [ aDialog deleteActionOn: self ];
				yourself.

	^ super addActions: aPresenter for: aDialog 
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

	| text |
	text := aPresenter newTextInput text: self content;
		whenTextChangedDo: [ :t | self content: t ].
	aPresenter layout add: text expand: true.
	^ self
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> attribute: anObject [

	description := anObject description.
	content := anObject content.
	isKey := anObject isKey.
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> beDeletable [

	self canDelete: true
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> beNotDeletable [

	self canDelete: false
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canDelete [

	^ canDelete ifNil: [ true ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> canDelete: aBoolean [

	canDelete := aBoolean.
	deleteButton ifNotNil: [ :button | button enabled: aBoolean ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> content [ 

	^ content ifNil: [ '' ]
]

{ #category : 'accessing' }
LDAPGenericAttributeTableLine >> content: anObject [

	content := anObject.
	addButton ifNotNil: [ :button | button enabled: content isNotEmpty ]
]

{ #category : 'ui building' }
LDAPGenericAttributeTableLine >> deleteButton: aPresenter for: aDialog [
	
	deleteButton := (self newDeleteButton: aPresenter)
				enabled: self canDelete;
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

	description := anObject
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

	isKey := anObject
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
