"
Replaces the entire attribute in the entry.
"
Class {
	#name : 'LDAPReplaceAttributesOperation',
	#superclass : 'LDAPModifyOperation',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'initialization' }
LDAPReplaceAttributesOperation >> initialize [ 
	super initialize.
	integer := 2. "Replace"
]

{ #category : 'accessing' }
LDAPReplaceAttributesOperation >> name [
	^ 'replace'
]
