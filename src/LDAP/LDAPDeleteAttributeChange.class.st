"
I am a list of attributes to add
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
