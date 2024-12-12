Class {
	#name : 'LDAPEntryEditorPresenterTest',
	#superclass : 'SpSmokeTest',
	#category : 'LDAP-UI-Tests',
	#package : 'LDAP-UI-Tests'
}

{ #category : 'running' }
LDAPEntryEditorPresenterTest >> application [

	^  self classToTest currentApplication

]

{ #category : 'accessing' }
LDAPEntryEditorPresenterTest >> classToTest [ 
	^ LDAPEntryEditorPresenter 
]
