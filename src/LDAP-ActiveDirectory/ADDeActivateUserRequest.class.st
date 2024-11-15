"
Request to deactivate an user.

The request DN is the user DN.
"
Class {
	#name : 'ADDeActivateUserRequest',
	#superclass : 'LDAPModifyRequest',
	#category : 'LDAP-ActiveDirectory-Requests',
	#package : 'LDAP-ActiveDirectory',
	#tag : 'Requests'
}

{ #category : 'initialization' }
ADDeActivateUserRequest >> initialize [ 

	super initialize.

	"ACCOUNTDISABLE 0x0002 + NORMAL_ACCOUNT 0x200"
	self addOperation: (LDAPSetAttributeChange new
		description: 'userAccountControl';
		addValue: (16r202 asString)
	).
]
