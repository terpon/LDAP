Class {
	#name : 'LDAPClipboardChanged',
	#superclass : 'Announcement',
	#instVars : [
		'text'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'accessing' }
LDAPClipboardChanged >> text [

	^ text
]

{ #category : 'accessing' }
LDAPClipboardChanged >> text: anObject [

	text := anObject
]
