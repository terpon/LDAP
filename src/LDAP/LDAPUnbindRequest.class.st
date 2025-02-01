"
I am the request sent before disconnecting the client of the LDAP server.

Contrary to its name, the unbind operation is not the symmetrical of the bind operation. After I am sent to the server, no other operation is expected on the connection.
"
Class {
	#name : 'LDAPUnbindRequest',
	#superclass : 'BERNull',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPUnbindRequest class >> tagValue [
	^ 16r42 "Application 2"
]
