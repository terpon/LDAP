"
Request to add a user DN to a group.

The request DN is the group DN.
"
Class {
	#name : 'ADGroupAddUserRequest',
	#superclass : 'LDAPModifyRequest',
	#instVars : [
		'addOperation'
	],
	#category : 'LDAP-ActiveDirectory-Requests',
	#package : 'LDAP-ActiveDirectory',
	#tag : 'Requests'
}

{ #category : 'adding' }
ADGroupAddUserRequest >> addUser: userDN [

	addOperation addValue: userDN
]

{ #category : 'adding' }
ADGroupAddUserRequest >> addUsers: aCollectionOfStrings [

	aCollectionOfStrings do: [ :user | self addUser: user ]
]

{ #category : 'initialization' }
ADGroupAddUserRequest >> initialize [ 

	super initialize.
	
	addOperation := LDAPAddAttributeChange new description: 'member'.
	self addOperation: addOperation.
]

{ #category : 'initialization' }
ADGroupAddUserRequest >> reset [

	addOperation removeAll.
]
