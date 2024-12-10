"
I add edit commands to the LDAP inspector
"
Class {
	#name : 'LDAPEditorPresenter',
	#superclass : 'LDAPInspectorPresenter',
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'callbacks' }
LDAPEditorPresenter >> invalidatePage: aDN [

	| page |
	page := miller pages detect: [ :p | p model name = aDN ] ifNone: [ ^self ].
	miller removeAllFrom: page.
]

{ #category : 'factory' }
LDAPEditorPresenter >> newEntryPresenterOn: anEntry [

	| presenter |
	presenter := LDAPEntryEditorPresenter newApplication: application model: anEntry.
	^ presenter
	
]
