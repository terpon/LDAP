"
I am announced when the connection is halted for whatever reason.
"
Class {
	#name : 'LDAPDisconnectionAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'cause'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPDisconnectionAnnouncement >> cause [

	^ cause
]

{ #category : 'accessing' }
LDAPDisconnectionAnnouncement >> cause: anObject [

	cause := anObject
]
