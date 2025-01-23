"
I represent a Secure LDAP Connection using SSL.
"
Class {
	#name : 'LDAPSConnection',
	#superclass : 'LDAPConnection',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'accessing - defaults' }
LDAPSConnection class >> defaultPort [

	^ 636
]

{ #category : 'instance creation' }
LDAPSConnection class >> socketClass [
	^ ZdcSecureSocketStream
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
