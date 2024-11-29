Class {
	#name : 'LDAPCachedEntry',
	#superclass : 'Object',
	#instVars : [
		'state'
	],
	#category : 'LDAP-Spec2-Models',
	#package : 'LDAP-Spec2',
	#tag : 'Models'
}

{ #category : 'instance creation' }
LDAPCachedEntry class >> on: anApplication for: aDN [

	| anEntry |
	anEntry := LDAPEntryModel new name: aDN.
	^ self new startOn: anApplication for: anEntry
	
]

{ #category : 'accessing' }
LDAPCachedEntry >> entry [

	^ state entry
]

{ #category : 'initialization' }
LDAPCachedEntry >> startOn: anApplication for: anEntry [

	state := LDAPEntryState on: anApplication for: anEntry
]

{ #category : 'updating' }
LDAPCachedEntry >> update [

	state atEnd ifTrue: [ ^ self ].
	
	[ 
		[ state atEnd ] whileFalse: [
			state := state next.
			Processor yield
		]
	] forkAt: Processor userBackgroundPriority named: 'LDAP update ', self entry name
]
