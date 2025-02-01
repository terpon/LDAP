"
I am an empty line used to create a custom attribute (not recognized by the selected object classes)
"
Class {
	#name : 'LDAPEmptyAttributeTableLine',
	#superclass : 'LDAPAbstractAttributeTableLine',
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'ui building' }
LDAPEmptyAttributeTableLine >> addButton: aPresenter for: aDialog [
	
	addButton := (self newAddButton: aPresenter)
				enabled: true;
				action: [ aDialog promptCustomAttribute ];
				yourself.
	
	self setButton: addButton in: aPresenter
]
