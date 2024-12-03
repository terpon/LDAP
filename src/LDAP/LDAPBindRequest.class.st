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
