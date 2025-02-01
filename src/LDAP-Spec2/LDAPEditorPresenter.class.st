"
I add edit commands to the LDAP inspector
"
Class {
	#name : 'LDAPEditorPresenter',
	#superclass : 'LDAPInspectorPresenter',
	#category : 'LDAP-Spec2-Entries',
	#package : 'LDAP-Spec2',
	#tag : 'Entries'
}

{ #category : 'accessing' }
LDAPEditorPresenter class >> currentApplication [ 
	^ LDAPEditor new
]

{ #category : 'initialization' }
LDAPEditorPresenter >> initializePresenters [ 

	super initializePresenters.
	
	statusBar toolbar 	addItemLeft: (self newToolbarButton 
			label: 'schema';
  			icon: (self iconNamed: #database);
     		help: 'Show current schema';
       	action: [ self openSchema ];
        	yourself).

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

{ #category : 'ui - dialogs' }
LDAPEditorPresenter >> openSchema [

	^ application openSchema
]

{ #category : 'updating - presenters' }
LDAPEditorPresenter >> updatePage: aDN [

	| page |
	page := miller pages detect: [ :p | p model name = aDN ] ifNone: [ ^self ].
	page updatePresenter.
]
