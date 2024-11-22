Class {
	#name : 'LDAPNamingContextsChange',
	#superclass : 'Announcement',
	#instVars : [
		'roots'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPNamingContextsChange >> roots [

	^ roots
]

{ #category : 'accessing' }
LDAPNamingContextsChange >> roots: anObject [

	roots := anObject
]
