"
A Secure LDAP Connection using SSL
"
Class {
	#name : 'LDAPSConnection',
	#superclass : 'LDAPConnection',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'instance creation' }
LDAPSConnection class >> socketClass [
	^ ZdcSecureSocketStream
]

{ #category : 'accessing - defaults' }
LDAPSConnection >> defaultPort [

	^ 636
]

{ #category : 'initialization' }
LDAPSConnection >> initializeSocket [

	| sockStream |
	sockStream := super initializeSocket.
		
	"SSL handshake"
	sockStream connect.

	^ sockStream
]

{ #category : 'testing' }
LDAPSConnection >> isSSL [
	^ true
]
