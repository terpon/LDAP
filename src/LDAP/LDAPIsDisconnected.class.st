"
I am announced when the connection is halted for whatever reason.
"
Class {
	#name : 'LDAPIsDisconnected',
	#superclass : 'Announcement',
	#instVars : [
		'cause'
	],
	#category : 'LDAP-Announcements',
	#package : 'LDAP',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPIsDisconnected >> cause [

	^ cause
]

{ #category : 'accessing' }
LDAPIsDisconnected >> cause: anObject [

	cause := anObject
]
