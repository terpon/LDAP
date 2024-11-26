"
I am announced whenever the received response from the server reports an error.
"
Class {
	#name : 'LDAPErrorAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'result'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPErrorAnnouncement >> result [

	^ result
]

{ #category : 'accessing' }
LDAPErrorAnnouncement >> result: anObject [

	result := anObject
]
