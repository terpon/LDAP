"
I report LDAPResult codes and messages to the Transcript.
"
Class {
	#name : 'LDAPTraceErrorHandler',
	#superclass : 'LDAPErrorHandler',
	#category : 'LDAP-Spec2-Tasks',
	#package : 'LDAP-Spec2',
	#tag : 'Tasks'
}

{ #category : 'reporting' }
LDAPTraceErrorHandler >> report: aLDAPResult [

	| message |
	message := String streamContents: [ :out |
		out
			nextPutAll: 'LDAP error: ';
			nextPutAll:  aLDAPResult resultElement printString.
		aLDAPResult name ifNotEmpty: [ :dn | 
			out nextPutAll: ' - dn: '; nextPutAll: dn
		].
		aLDAPResult diagnosticMessage ifNotEmpty: [ :msg |
			out nextPutAll: ' - '; nextPutAll: msg
		]
	].
	message traceCr.
]
