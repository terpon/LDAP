"
I am a request to abondon a previous request.

The server will not generate a response to my request. The abandoned request can still be procsessed.
There exists a cancel request extension which has a result response. The cancel request is not currently supported.
"
Class {
	#name : 'LDAPAbandonRequest',
	#superclass : 'BERInteger',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'instance creation' }
LDAPAbandonRequest class >> newId: anId [
	^ self new content: anId; yourself
]

{ #category : 'accessing' }
LDAPAbandonRequest class >> tagValue [
	^ 16r50 "Application 16"
]
