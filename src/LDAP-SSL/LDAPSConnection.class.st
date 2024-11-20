"
A Secure LDAP Connection using SSL
"
Class {
	#name : 'LDAPSConnection',
	#superclass : 'LDAPConnection',
	#category : 'LDAP-SSL',
	#package : 'LDAP-SSL'
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
