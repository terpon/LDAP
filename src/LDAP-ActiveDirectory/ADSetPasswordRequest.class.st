"
Request to reset a password.

The request DN is the user DN.
"
Class {
	#name : 'ADSetPasswordRequest',
	#superclass : 'LDAPModifyRequest',
	#instVars : [
		'setOperation'
	],
	#category : 'LDAP-ActiveDirectory-Requests',
	#package : 'LDAP-ActiveDirectory',
	#tag : 'Requests'
}

{ #category : 'converting' }
ADSetPasswordRequest class >> encodedPassword: aString [
	^ String
		streamContents: [ :writeStream | 
			UTF16TextConverter new
				useLittleEndian: true;
				nextPut: $" toStream: writeStream;
				nextPutAll: aString toStream: writeStream;
				nextPut: $" toStream: writeStream ]
]

{ #category : 'initialization' }
ADSetPasswordRequest >> initialize [ 

	super initialize.
	
	setOperation := LDAPSetAttributeChange new description: 'unicodePwd'.
	self addOperation: setOperation.
]

{ #category : 'accessing' }
ADSetPasswordRequest >> password: aString [
	| encoded |
	encoded := self class encodedPassword: aString.
	setOperation values: {encoded}.

]
