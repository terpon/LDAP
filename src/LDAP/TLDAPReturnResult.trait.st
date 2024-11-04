"
I implement the message processResult: on LDAP requests types.


"
Trait {
	#name : 'TLDAPReturnResult',
	#category : 'LDAP-Requests',
	#package : 'LDAP',
	#tag : 'Requests'
}

{ #category : 'testing' }
TLDAPReturnResult >> processSuccessFor: aCollection [
"For basic requests, there is only one response."
	^ aCollection allSatisfy: [ :response | response success ]
]
