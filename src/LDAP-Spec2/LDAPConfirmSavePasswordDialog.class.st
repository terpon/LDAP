"
I am a dialog to keep or clear the password before saving it to file
"
Class {
	#name : 'LDAPConfirmSavePasswordDialog',
	#superclass : 'SpConfirmDialog',
	#instVars : [
		'clearLabel',
		'clearAction'
	],
	#category : 'LDAP-Spec2-Servers',
	#package : 'LDAP-Spec2',
	#tag : 'Servers'
}

{ #category : 'initialization' }
LDAPConfirmSavePasswordDialog >> addButtonsTo: aDialogWindowPresenter [

	"To have a specific order, do not call super method"
	aDialogWindowPresenter 
		addButton: self cancelLabel do: [ :presenter | self cancel ];
		addDefaultButton: self clearLabel do: [ :presenter | self clear ];
		addDefaultButton: self acceptLabel do: [ :presenter | self accept ]
]

{ #category : 'private' }
LDAPConfirmSavePasswordDialog >> clear [

	self window 	beOk.
	clearAction ifNotNil: [ :block | block value ].
	self window close.
]

{ #category : 'accessing' }
LDAPConfirmSavePasswordDialog >> clearLabel [

	^ clearLabel
]

{ #category : 'accessing' }
LDAPConfirmSavePasswordDialog >> clearLabel: aString [

	clearLabel := aString
]

{ #category : 'initialization' }
LDAPConfirmSavePasswordDialog >> initialize [ 

	super initialize.
	
	self title: 'A password is set'.
	self label: 'Keep the password in the bookmark entry?'.
	self cancelLabel: 'Cancel'.
	self clearLabel: 'Clear'.
	self acceptLabel: 'Keep'.

]

{ #category : 'api - events' }
LDAPConfirmSavePasswordDialog >> onClear: aBlock [
	"Action on the clear button"

	clearAction := aBlock
]
