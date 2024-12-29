Class {
	#name : 'LDAPAttributeTableLine',
	#superclass : 'Object',
	#instVars : [
		'attribute'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'adding' }
LDAPAttributeTableLine >> addActions: aPresenter [
	
	aPresenter layout
		add: (aPresenter newButton 
				addStyle: 'small'; 
				icon: (aPresenter iconNamed: #smallAoo);
				yourself);
		add: (aPresenter newButton 
				addStyle: 'small'; 
				icon: (aPresenter iconNamed: #smallDelete);
				yourself).

	^ self
]

{ #category : 'adding' }
LDAPAttributeTableLine >> addContentPresenter: aPresenter [

	| label |
	label := aPresenter newLabel label: self content.
	aPresenter layout add: label.
	^ self
]

{ #category : 'accessing' }
LDAPAttributeTableLine >> attribute: anObject [

	attribute := anObject
]

{ #category : 'accessing' }
LDAPAttributeTableLine >> content [ 

	^ attribute content
]

{ #category : 'accessing' }
LDAPAttributeTableLine >> description [ 

	^ attribute description
]

{ #category : 'accessing' }
LDAPAttributeTableLine >> icon [ 

	^ self iconNamed: #blank
]
