"
I am announced whenever the LDAPEditor clipboard content is changed.
"
Class {
	#name : 'LDAPClipboardChanged',
	#superclass : 'Announcement',
	#instVars : [
		'content'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPClipboardChanged >> content [

	^ content
]

{ #category : 'accessing' }
LDAPClipboardChanged >> content: anObject [

	content := anObject
]
