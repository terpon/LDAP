"
Request to abondon a request
"
Class {
	#name : 'LDAPAbandonRequest',
	#superclass : 'BERInteger',
	#traits : 'TLDAPReturnResult',
	#classTraits : 'TLDAPReturnResult classTrait',
	#category : 'LDAP-Requests',
	#package : 'LDAP',
	#tag : 'Requests'
}

{ #category : 'accessing' }
LDAPAbandonRequest class >> tagValue [
	^ 16r50 "Application 16"
]

{ #category : 'accessing' }
LDAPAbandonRequest >> abandonId: anAbandonMessageId [
	self value: anAbandonMessageId.

]
