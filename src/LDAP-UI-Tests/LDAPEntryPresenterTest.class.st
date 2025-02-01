Class {
	#name : 'LDAPEntryPresenterTest',
	#superclass : 'SpSmokeTest',
	#category : 'LDAP-UI-Tests',
	#package : 'LDAP-UI-Tests'
}

{ #category : 'running' }
LDAPEntryPresenterTest >> application [

	^  self classToTest currentApplication

]

{ #category : 'accessing' }
LDAPEntryPresenterTest >> classToTest [ 
	^ LDAPEntryPresenter 
]
