"
I am a list of attributes to delete.

If there are no attributes values, all attributes with the given description are deleted.
"
Class {
	#name : 'LDAPDeleteAttributeChange',
	#superclass : 'LDAPAttributeChange',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPDeleteAttributeChange >> initialize [ 
	super initialize.
	
	elements at: 1 put: (LDAPDeleteAttributesOperation new).

]
