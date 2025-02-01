Class {
	#name : 'LDAPRequiredAttributeTableLine',
	#superclass : 'LDAPKnownAttributeTableLine',
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'testing' }
LDAPRequiredAttributeTableLine class >> canDeleteLast [

	^ false
]

{ #category : 'accessing' }
LDAPRequiredAttributeTableLine >> bold [

	^ true
]

{ #category : 'accessing' }
LDAPRequiredAttributeTableLine >> help [

	^ 'Required Attribute Type'
]

{ #category : 'testing' }
LDAPRequiredAttributeTableLine >> isRequired [ 

	^ true
]
