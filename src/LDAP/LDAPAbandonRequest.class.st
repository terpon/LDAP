"
Request to abondon a request
"
Class {
	#name : 'LDAPAbandonRequest',
	#superclass : 'BERInteger',
	#category : 'LDAP-Requests',
	#package : 'LDAP',
	#tag : 'Requests'
}

{ #category : 'instance creation' }
LDAPAbandonRequest class >> newId: anId [
	^ self new value: anId; yourself
]

{ #category : 'accessing' }
LDAPAbandonRequest class >> tagValue [
	^ 16r50 "Application 16"
]
