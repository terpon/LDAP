"
I am the abstract class representing the connection type to the LDAP server.

Currently, only plaintext TCP (basic) and SSL over TCP are supported. (Microsoft Active Directory has some UDP functionality for querying the server DSE)
"
Class {
	#name : 'LDAPConnectionType',
	#superclass : 'Object',
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'testing' }
LDAPConnectionType class >> isAbstract [ 
	"For collecting only concrete subclasses"
	^ self = LDAPConnectionType
]

{ #category : 'comparing' }
LDAPConnectionType >> = anObject [

	^ self class == anObject class
]

{ #category : 'instance creation' }
LDAPConnectionType >> connectionClass [

	self subclassResponsibility.
	^ nil
]

{ #category : 'accessing - defaults' }
LDAPConnectionType >> defaultPort [

	^ self connectionClass defaultPort
]

{ #category : 'comparing' }
LDAPConnectionType >> hash [

	^ self className hash
]

{ #category : 'displaying' }
LDAPConnectionType >> presenterText [

	self subclassResponsibility.
	^ 'unknown'
]

{ #category : 'accessing' }
LDAPConnectionType >> scheme [

	self subclassResponsibility.
	^ 'unknown'
]
