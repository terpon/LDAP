"
I am a set of attributes saved in the editor clipboard
"
Class {
	#name : 'LDAPClipboardCopyAttributes',
	#superclass : 'LDAPClipboardName',
	#instVars : [
		'attributes'
	],
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'comparing' }
LDAPClipboardCopyAttributes >> = anObject [
	
	(super = anObject) ifFalse: [ ^ false ].
	^ self attributes = anObject attributes
]

{ #category : 'accessing' }
LDAPClipboardCopyAttributes >> attributes [

	^ attributes ifNil: [ #() ]
]

{ #category : 'accessing' }
LDAPClipboardCopyAttributes >> attributes: anObject [

	attributes := anObject
]

{ #category : 'testing' }
LDAPClipboardCopyAttributes >> canBePastedAt: aName [

"Maybe schema or server will forbid it, but a subentry can always be created"
	^ true
]

{ #category : 'testing' }
LDAPClipboardCopyAttributes >> isValidOnInvalidateName: aName [
	
	"self name is purely informational, we use the copied attributes on paste"
	^ true
]

{ #category : 'clipboard handling' }
LDAPClipboardCopyAttributes >> pasteAt: aName in: anApplication [

	^ anApplication openNewEntryDialogUnder: aName with: self attributes
]
