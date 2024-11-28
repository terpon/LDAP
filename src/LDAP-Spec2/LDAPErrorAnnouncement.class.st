"
I am announced whenever the received response from the server reports an error.
"
Class {
	#name : 'LDAPErrorAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'command'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPErrorAnnouncement >> command [

	^ command
]

{ #category : 'accessing' }
LDAPErrorAnnouncement >> command: anObject [

	command := anObject
]
