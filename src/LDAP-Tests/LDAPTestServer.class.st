"
I am an utility class for test.

I define on my class side default values for the test. 
I expect a LDAP server on localhost, on default port 389 and also 636 for SSL. It has a naming context of 'dc=example,dc=com'.
"
Class {
	#name : 'LDAPTestServer',
	#superclass : 'Object',
	#category : 'LDAP-Tests-Utility',
	#package : 'LDAP-Tests',
	#tag : 'Utility'
}

{ #category : 'accessing - defaults' }
LDAPTestServer class >> hostname [

	^ 'localhost'
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> ip [

	^ '127.0.0.1'
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> namingContext [

	^ 'dc=example,dc=com'
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> password [
	^ 'secret'
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> port [

	^ 389
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> sslPort [

	^ 636
]

{ #category : 'accessing - defaults' }
LDAPTestServer class >> username [

	^ 'cn=admin,dc=example,dc=com'
]
