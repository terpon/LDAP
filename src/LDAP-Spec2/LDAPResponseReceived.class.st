Class {
	#name : 'LDAPResponseReceived',
	#superclass : 'Announcement',
	#instVars : [
		'command'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPResponseReceived >> command [

	^ command
]

{ #category : 'accessing' }
LDAPResponseReceived >> command: anObject [

	command := anObject
]
