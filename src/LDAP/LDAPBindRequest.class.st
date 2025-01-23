"
I am a request to send user credentials to the server.
The connection to the server starts as unauthenticated state.

LDAPv3 supports two basic types of authentication:
  - Simple authentication, in which the client identifies itself with a DN and proves its identity with a password.
  - SASL (Simple Authentication and Security Layer) authentication

Currently I only support simple authentication. Password is in clear text in the BER element so sensitive connections should only be performed with a SSL connection.
"
Class {
	#name : 'LDAPBindRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Connection',
	#package : 'LDAP',
	#tag : 'Connection'
}

{ #category : 'accessing' }
LDAPBindRequest class >> tagValue [
	^ 16r60 "Application 0"
]

{ #category : 'initialization' }
LDAPBindRequest >> initialize [ 
	super initialize.
	
	self addElement: (BERInteger new content: 3). "version"
	self addElement: (LDAPString new). "name"
	self addElement: (LDAPSimpleAuthString new). "simple"

]

{ #category : 'accessing' }
LDAPBindRequest >> password [

	^ elements third content
]

{ #category : 'accessing' }
LDAPBindRequest >> password: aString [
	elements third content: aString
]

{ #category : 'accessing' }
LDAPBindRequest >> username [

	^ elements second content
]

{ #category : 'accessing' }
LDAPBindRequest >> username: aString [
	elements second content: aString
]

{ #category : 'versions' }
LDAPBindRequest >> version [

	^ elements first asInteger
]
