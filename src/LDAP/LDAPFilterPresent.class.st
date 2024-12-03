"
A present filter
"
Class {
	#name : 'LDAPFilterPresent',
	#superclass : 'LDAPString',
	#traits : 'TLDAPComposeFilter',
	#classTraits : 'TLDAPComposeFilter classTrait',
	#category : 'LDAP-Filters',
	#package : 'LDAP',
	#tag : 'Filters'
}

{ #category : 'instance creation' }
LDAPFilterPresent class >> having: anAttrType [
	^ self new content: anAttrType

]

{ #category : 'accessing' }
LDAPFilterPresent class >> tagValue [
	^ 16r87 "Context 7"
]
