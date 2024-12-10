Class {
	#name : 'LDAPSchema',
	#superclass : 'Object',
	#instVars : [
		'classes',
		'aliases'
	],
	#category : 'LDAP-Schema',
	#package : 'LDAP',
	#tag : 'Schema'
}

{ #category : 'initialization' }
LDAPSchema >> initialize [ 
	super initialize.
	
	classes := Set new.
	aliases := Dictionary new.
]
