Class {
	#name : 'LDAPEmptyAttributeTableLine',
	#superclass : 'Object',
	#instVars : [
		'configButton',
		'addButton',
		'deleteButton'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'testing' }
LDAPEmptyAttributeTableLine class >> canDeleteLast [

	^ true
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> addActions: aPresenter for: aDialog [

	self setButton: configButton in: aPresenter.
	self setButton: addButton in: aPresenter.
	self setButton: deleteButton in: aPresenter.

	^ self
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> addButton: aPresenter for: aDialog [
	
	addButton := (self newAddButton: aPresenter)
				enabled: true;
				action: [ aDialog promptCustomAttribute ];
				yourself.
	
	self setButton: addButton in: aPresenter
]

{ #category : 'adding' }
LDAPEmptyAttributeTableLine >> addContentPresenter: aPresenter [

	"Nothing"
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> bold [

	^ false
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> configButton: aPresenter for: aDialog [
	
	"Nothing here"
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> content [

	^ ''
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> deleteButton: aPresenter for: aDialog [
	
	"Nothing here"
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> description [

	^ ''
]

{ #category : 'converting' }
LDAPEmptyAttributeTableLine >> entryAttribute [
	
	| class  |
	class := self entryAttributeClass.
	
	^ class new description: self description; content: self content; yourself
]

{ #category : 'converting' }
LDAPEmptyAttributeTableLine >> entryAttributeClass [

	^ LDAPLeafEntryAttribute
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> help [

	^ nil
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> icon [ 

	^ self iconNamed: #blank
]

{ #category : 'accessing' }
LDAPEmptyAttributeTableLine >> isKey [
	^ false
]

{ #category : 'testing' }
LDAPEmptyAttributeTableLine >> isKnown [

	^ false
]

{ #category : 'testing' }
LDAPEmptyAttributeTableLine >> isRequired [

	^ false
]

{ #category : 'testing' }
LDAPEmptyAttributeTableLine >> isSpecial [

	^ true
]

{ #category : 'testing' }
LDAPEmptyAttributeTableLine >> isValid [

	^ false
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> keyCheckbox: aPresenter for: aDialog [
	
"Nothing by default"
]

{ #category : 'adding' }
LDAPEmptyAttributeTableLine >> newAddButton: aPresenter [
	
	^ aPresenter newButton 
				addStyle: 'small'; addStyle: 'flat'; 
				icon: (aPresenter iconNamed: #smallAdd);
				enabled: self content isNotEmpty;
				yourself
]

{ #category : 'adding' }
LDAPEmptyAttributeTableLine >> newDeleteButton: aPresenter [
	
	^ aPresenter newButton 
				addStyle: 'small'; addStyle: 'flat'; 
				icon: (aPresenter iconNamed: #smallCancel);
				yourself
]

{ #category : 'testing' }
LDAPEmptyAttributeTableLine >> sameTypeAs: anObject [

	^ false
]

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> setButton: aButton in: aPresenter [
	
	aButton ifNotNil: [ aPresenter layout add: aButton expand: false ]
]
