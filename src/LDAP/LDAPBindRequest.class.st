"
LDAPBindRequest is the connection process to the LDAP directory.
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
	
	self addElement: (BERInteger new value: 3). "version"
	self addElement: (BEROctetString new). "name"
	self addElement: (LDAPSimpleAuthString new). "simple"

]

{ #category : 'accessing' }
LDAPBindRequest >> password [

	^ elements third value
]

{ #category : 'accessing' }
LDAPBindRequest >> password: aString [
	elements third value: aString
]

{ #category : 'accessing' }
LDAPBindRequest >> username [

	^ elements second value
]

{ #category : 'accessing' }
LDAPBindRequest >> username: aString [
	elements second value: aString
]

{ #category : 'versions' }
LDAPBindRequest >> version [

	^ elements first value
]
