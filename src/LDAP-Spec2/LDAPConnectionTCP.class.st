"
I am the basic LDAP connection type
"
Class {
	#name : 'LDAPConnectionTCP',
	#superclass : 'LDAPConnectionType',
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'instance creation' }
LDAPConnectionTCP >> connectionClass [ 
	^ LDAPConnection
]

{ #category : 'displaying' }
LDAPConnectionTCP >> presenterText [

	^ 'Basic (TCP)'
]

{ #category : 'accessing' }
LDAPConnectionTCP >> scheme [
	^ 'ldap'
]
