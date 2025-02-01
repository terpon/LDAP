"
I am a list of attributes to replace.
"
Class {
	#name : 'LDAPSetAttributeChange',
	#superclass : 'LDAPAttributeChange',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPSetAttributeChange >> initialize [ 
	super initialize.
	
	elements at: 1 put: (LDAPReplaceAttributesOperation new).

]
