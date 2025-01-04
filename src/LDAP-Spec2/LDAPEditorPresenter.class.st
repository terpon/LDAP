"
I add edit commands to the LDAP inspector
"
Class {
	#name : 'LDAPEditorPresenter',
	#superclass : 'LDAPInspectorPresenter',
	#category : 'LDAP-Spec2-Windows',
	#package : 'LDAP-Spec2',
	#tag : 'Windows'
}

{ #category : 'accessing' }
LDAPEditorPresenter class >> currentApplication [ 
	^ LDAPEditor new
]

{ #category : 'updating - presenters' }
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

{ #category : 'updating - presenters' }
LDAPEditorPresenter >> updatePage: aDN [

	| page |
	page := miller pages detect: [ :p | p model name = aDN ] ifNone: [ ^self ].
	page updatePresenter.
]
