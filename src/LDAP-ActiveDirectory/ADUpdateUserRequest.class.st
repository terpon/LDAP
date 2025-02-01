"
Request to update an user.

The request DN is the user DN.
"
Class {
	#name : 'ADUpdateUserRequest',
	#superclass : 'LDAPModifyRequest',
	#category : 'LDAP-ActiveDirectory-Requests',
	#package : 'LDAP-ActiveDirectory',
	#tag : 'Requests'
}

{ #category : 'accessing' }
ADUpdateUserRequest >> email: aString [
	self set: 'mail' to: aString.

]

{ #category : 'accessing' }
ADUpdateUserRequest >> fullName: aString [
	self set: 'displayName' to: aString.

]

{ #category : 'accessing' }
ADUpdateUserRequest >> givenName: aString [
	self set: 'givenName' to: aString.

]

{ #category : 'accessing' }
ADUpdateUserRequest >> surName: aString [
	self set: 'sn' to: aString.

]
