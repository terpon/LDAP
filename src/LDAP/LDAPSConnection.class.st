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

{ #category : 'accessing' }
LDAPSConnection class >> workerClass [
	^ LDAPSWorker
]

{ #category : 'accessing - defaults' }
LDAPSConnection >> defaultPort [

	^ 636
]

{ #category : 'testing' }
LDAPSConnection >> isSSL [
	^ true
]
