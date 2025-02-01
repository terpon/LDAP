"
I am a Null Object content for the LDAP editor clipboard
"
Class {
	#name : 'LDAPClipboardNull',
	#superclass : 'Object',
	#category : 'LDAP-Spec2-Clipboard',
	#package : 'LDAP-Spec2',
	#tag : 'Clipboard'
}

{ #category : 'comparing' }
LDAPClipboardNull >> = anObject [
	
	"All null objects are equal"
	^ self class = anObject class
]

{ #category : 'testing' }
LDAPClipboardNull >> canBePastedAt: aName [

"Should be overriden"
	^ false
]

{ #category : 'testing' }
LDAPClipboardNull >> isValidOnInvalidateName: aName [
	
	^ true
]

{ #category : 'clipboard handling' }
LDAPClipboardNull >> pasteAt: aName in: anApplication [

	self subclassResponsibility
]
