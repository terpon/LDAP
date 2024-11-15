"
Request to modify a distinguished name
"
Class {
	#name : 'LDAPModifyDNRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Modify',
	#package : 'LDAP',
	#tag : 'Modify'
}

{ #category : 'accessing' }
LDAPModifyDNRequest class >> tagValue [
	^ 16r6C "Application 12"
]

{ #category : 'initialization' }
LDAPModifyDNRequest >> initialize [ 
	super initialize.
	
	self addElement: (BEROctetString new). "entry"
	self addElement: (BEROctetString new). "newrdn"
	self addElement: (BERBoolean new). "deleteoldrdn"

]

{ #category : 'accessing' }
LDAPModifyDNRequest >> name: aDn [
	elements first value: aDn
]

{ #category : 'accessing' }
LDAPModifyDNRequest >> newRelativeName: aRdn [
	elements second value: aRdn
]

{ #category : 'accessing' }
LDAPModifyDNRequest >> underName: aDn [
	elements size < 4 ifTrue: [ elements addElement: (LDAPOptionalDN new)].
	elements fourth value: aDn
]

{ #category : 'accessing' }
LDAPModifyDNRequest >> wantToClearAttrs: aBoolean [
	elements third value: aBoolean
]
