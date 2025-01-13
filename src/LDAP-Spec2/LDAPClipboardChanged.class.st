"
I am announced whenever the LDAPEditor clipboard content is changed.
"
Class {
	#name : 'LDAPClipboardChanged',
	#superclass : 'Announcement',
	#instVars : [
		'content'
	],
	#category : 'LDAP-Spec2-Clipboard',
	#package : 'LDAP-Spec2',
	#tag : 'Clipboard'
}

{ #category : 'accessing' }
LDAPClipboardChanged >> content [

	^ content
]

{ #category : 'accessing' }
LDAPClipboardChanged >> content: anObject [

	content := anObject
]
