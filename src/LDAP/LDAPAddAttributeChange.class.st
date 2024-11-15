"
I am a list of attributes to add
"
Class {
	#name : 'LDAPAddAttributeChange',
	#superclass : 'LDAPAttributeChange',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPAddAttributeChange >> initialize [ 
	super initialize.
	
	elements at: 1 put: (LDAPAddAttributesOperation new).

]
