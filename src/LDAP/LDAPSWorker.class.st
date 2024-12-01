"
A secure worker (thread)
"
Class {
	#name : 'LDAPSWorker',
	#superclass : 'LDAPWorker',
	#category : 'LDAP-Internal',
	#package : 'LDAP',
	#tag : 'Internal'
}

{ #category : 'instance creation' }
LDAPSWorker class >> socketClass [
	^ ZdcSecureSocketStream
]

{ #category : 'connecting' }
LDAPSWorker >> postConnect [
	"SSL handshake"
	sockStream connect.
]
