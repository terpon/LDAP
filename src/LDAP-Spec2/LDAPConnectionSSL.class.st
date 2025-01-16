"
I am the LDAP connection with a TCP SSL socket
"
Class {
	#name : 'LDAPConnectionSSL',
	#superclass : 'LDAPConnectionType',
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'instance creation' }
LDAPConnectionSSL >> connectionClass [ 
	^ LDAPSConnection
]

{ #category : 'displaying' }
LDAPConnectionSSL >> presenterText [

	^ 'SSL'
]

{ #category : 'accessing' }
LDAPConnectionSSL >> scheme [
	^ 'ldaps'
]
