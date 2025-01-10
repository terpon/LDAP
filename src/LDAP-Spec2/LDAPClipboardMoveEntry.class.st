"
I am a clipboard paste action who will open a move dialog (ModifyDN)
"
Class {
	#name : 'LDAPClipboardMoveEntry',
	#superclass : 'LDAPClipboardName',
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'testing' }
LDAPClipboardMoveEntry >> canBePastedAt: aName [

"The entry cannot be moved under itself"
	(LDAPName is: name under: aName) ifTrue: [ ^ false ].

	^ true
]

{ #category : 'testing' }
LDAPClipboardMoveEntry >> isValidOnInvalidateName: aName [
	
	"If a parent of mine have been moved or deleted, I must be cleared"
	^ (LDAPName is: name under: aName) not
]

{ #category : 'clipboard handling' }
LDAPClipboardMoveEntry >> pasteAt: aName in: anApplication [

	| underDN newRDN aRequest |
	underDN := aName.
	newRDN := LDAPName firstName: name.
	aRequest := LDAPModifyNameRequest new
		name: name;
		newRelativeName: newRDN;
		underName: underDN;
		yourself.

	^ SpConfirmDialog new
		  title: 'Confirm paste entry';
		  label: (Text streamContents: [ :stream |
				stream nextPutAll: 'About to move '; nextPutAll: (anApplication formattedTextFor: name); cr;
					nextPutAll: 'under '; nextPutAll: (anApplication formattedTextFor: underDN)
			]);
		  acceptLabel: 'Move';
		  cancelLabel: 'Cancel';
		  onAccept: [ anApplication sendModifyName: aRequest ];
		  onCancel: [ :d | anApplication inform: 'Cancelled move entry ' , name ];
		  openDialog

]
