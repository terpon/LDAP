Class {
	#name : 'LDAPObjectClassTableLine',
	#superclass : 'LDAPAbstractAttributeTableLine',
	#instVars : [
		'objectClass'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'testing' }
LDAPObjectClassTableLine class >> canDeleteLast [

	^ false
]

{ #category : 'instance creation' }
LDAPObjectClassTableLine class >> unknown: aName [

	^ LDAPCustomAttributeTableLine new description: 'objectClass'; content: aName; yourself
]

{ #category : 'ui building' }
LDAPObjectClassTableLine >> addButton: aPresenter for: aDialog [
	
	addButton := (self newAddButton: aPresenter)
				action: [ aDialog addActionOn: self ];
				yourself.
	
	self setButton: addButton in: aPresenter
]

{ #category : 'adding' }
LDAPObjectClassTableLine >> addContentPresenter: aPresenter [

	contentPresenter := aPresenter newLabel label: self content.
	aPresenter layout add: contentPresenter.
	^ self
]

{ #category : 'ui building' }
LDAPObjectClassTableLine >> configButton: aPresenter for: aDialog [
	
	configButton := aPresenter newButton 
				addStyle: 'small'; addStyle: 'flat'; 
				icon: (aPresenter iconNamed: #smallConfiguration);
				action: [ aDialog selectObjectClass: self ]
				yourself.

	 self setButton: configButton in: aPresenter
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> content [ 

	^ objectClass ifNil: [ '' ] ifNotNil: [ :oc | oc name ]
]

{ #category : 'ui building' }
LDAPObjectClassTableLine >> deleteButton: aPresenter for: aDialog [
	
	deleteButton := (self newDeleteButton: aPresenter)
				action: [ aDialog deleteObjectClassActionOn: self ];
				yourself.

	 self setButton: deleteButton in: aPresenter
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> description [

	^ 'objectClass'
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> help [
	^ 'Object Class Attribute'
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> icon [ 

	^ self iconNamed: #smallHierarchyBrowser
]

{ #category : 'testing' }
LDAPObjectClassTableLine >> isKnown [

	^ true
]

{ #category : 'testing' }
LDAPObjectClassTableLine >> isRequired [ 

	^ true
]

{ #category : 'testing' }
LDAPObjectClassTableLine >> isValid [

	^ self content isNotEmpty
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> objectClass [

	^ objectClass
]

{ #category : 'accessing' }
LDAPObjectClassTableLine >> objectClass: anObject [

	objectClass := anObject
]

{ #category : 'testing' }
LDAPObjectClassTableLine >> sameTypeAs: anObject [

	^ self class = anObject class
]
