"
I am announced whenever the received response from the server reports an error.
"
Class {
	#name : 'LDAPError',
	#superclass : 'Announcement',
	#instVars : [
		'result'
	],
	#category : 'LDAP-Spec2-Announcements',
	#package : 'LDAP-Spec2',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
LDAPError >> result [

	^ result
]

{ #category : 'accessing' }
LDAPError >> result: anObject [

	result := anObject
]
