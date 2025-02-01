"
Request to activate an user.

The request DN is the user DN.
"
Class {
	#name : 'ADActivateUserRequest',
	#superclass : 'LDAPModifyRequest',
	#category : 'LDAP-ActiveDirectory-Requests',
	#package : 'LDAP-ActiveDirectory',
	#tag : 'Requests'
}

{ #category : 'initialization' }
ADActivateUserRequest >> initialize [ 

	super initialize.
	
	"NORMAL_ACCOUNT 0x200 + DONT_EXPIRE_PASSWORD 0x10000"
	self addOperation: (LDAPSetAttributeChange new 
		description: 'userAccountControl';
		addValue: (16r10200 asString)
	).
]
