Class {
	#name : 'LDAPAbstractAttributeTableLine',
	#superclass : 'Object',
	#instVars : [
		'configButton',
		'addButton',
		'deleteButton',
		'contentPresenter'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'testing' }
LDAPAbstractAttributeTableLine class >> canDeleteLast [

	^ true
]

{ #category : 'ui building' }
LDAPAbstractAttributeTableLine >> addButton: aPresenter for: aDialog [
	
	"Nothing here"
]

{ #category : 'adding' }
LDAPAbstractAttributeTableLine >> addContentPresenter: aPresenter [

	"Nothing"
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> bold [

	^ false
]

{ #category : 'ui building' }
LDAPAbstractAttributeTableLine >> configButton: aPresenter for: aDialog [
	
	"Nothing here"
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> content [

	^ ''
]

{ #category : 'ui building' }
LDAPAbstractAttributeTableLine >> deleteButton: aPresenter for: aDialog [
	
	"Nothing here"
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> description [

	^ ''
]

{ #category : 'converting' }
LDAPAbstractAttributeTableLine >> entryAttribute [
	
	| class  |
	class := self entryAttributeClass.
	
	^ class new description: self description; content: self content; yourself
]

{ #category : 'converting' }
LDAPAbstractAttributeTableLine >> entryAttributeClass [

	^ LDAPLeafEntryAttribute
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> help [

	^ nil
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> icon [ 

	^ self iconNamed: #blank
]

{ #category : 'accessing' }
LDAPAbstractAttributeTableLine >> isKey [
	^ false
]

{ #category : 'testing' }
LDAPAbstractAttributeTableLine >> isKnown [

	^ false
]

{ #category : 'testing' }
LDAPAbstractAttributeTableLine >> isRequired [

	^ false
]

{ #category : 'testing' }
LDAPAbstractAttributeTableLine >> isSpecial [

	^ true
]

{ #category : 'testing' }
LDAPAbstractAttributeTableLine >> isValid [

	^ false
]

{ #category : 'ui building' }
LDAPAbstractAttributeTableLine >> keyCheckbox: aPresenter for: aDialog [
	
"Nothing by default"
]

{ #category : 'adding' }
LDAPAbstractAttributeTableLine >> newAddButton: aPresenter [
	
	^ aPresenter newButton 
				addStyle: 'small'; addStyle: 'flat'; 
				icon: (aPresenter iconNamed: #smallAdd);
				enabled: self content isNotEmpty;
				yourself
]

{ #category : 'adding' }
LDAPAbstractAttributeTableLine >> newDeleteButton: aPresenter [
	
	^ aPresenter newButton 
				addStyle: 'small'; addStyle: 'flat'; 
				icon: (aPresenter iconNamed: #smallCancel);
				yourself
]

{ #category : 'testing' }
LDAPAbstractAttributeTableLine >> sameTypeAs: anObject [

	^ false
]

{ #category : 'ui building' }
LDAPAbstractAttributeTableLine >> setButton: aButton in: aPresenter [
	
	aButton ifNotNil: [ aPresenter layout add: aButton expand: false ]
]

{ #category : 'updating - presenters' }
LDAPAbstractAttributeTableLine >> updatePresenters [

	"Nothing"
]
