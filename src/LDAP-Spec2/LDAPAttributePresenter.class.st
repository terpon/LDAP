"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'checks',
		'text',
		'attributes'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPAttributePresenter class >> example [
	| aModel |
	aModel := self sampleElement.
	"result inspect."
	^ (self on: aModel) inspect; open 

]

{ #category : 'examples' }
LDAPAttributePresenter class >> sampleElement [
"Sample search result"
	| entry list |
	entry := LDAPSearchResultEntry new.
	entry addElement: (LDAPString new content: 'cn=foo,dc=example,dc=com').
	list := LDAPPartialAttributeList new addAll: { 
				LDAPPartialAttribute new description: 'objectClass'; values: 'person'; yourself.
				LDAPPartialAttribute new description: 'cn'; values: 'foo'; yourself.
				LDAPPartialAttribute new description: 'sn'; values: { 'bar'. 'nox' }; yourself 
			 }; yourself.
	entry addElement: list.
	^ entry flattened 

]

{ #category : 'layout' }
LDAPAttributePresenter >> defaultLayout [ 

	table removeColumn: checks.
	
	^ SpBoxLayout newTopToBottom
		add: text expand: false;
		add: table;
		yourself
]

{ #category : 'initialization' }
LDAPAttributePresenter >> initializePresenters [ 

	text := self newText beNotEditable; beWrapWord.
	checks := SpCheckBoxTableColumn new
			beNotExpandable; width: 20;
			evaluated: [ :each | self statusFor: each ].
	table := self newTable
		isResizable: true;
		addColumn: checks;
		addColumn: (SpStringTableColumn new
			title: 'Attribute';
			beEditable;
			evaluated: [ :each | each first ];
			yourself);
		addColumn: (SpStringTableColumn new
			title: 'Value'; 
			beEditable;
			evaluated: [ :each | each second ]);
	yourself.
]

{ #category : 'initialization' }
LDAPAttributePresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.
	aSpWindowPresenter title: self className.
]

{ #category : 'layout' }
LDAPAttributePresenter >> newEntryLayout [ 

	text text: 'Check the attribute to use as relative distinguished name'.
	(table columns first == checks) ifFalse: [
		| columns |
		columns := table columns copy.
		table columns: { checks }.
		table addColumns: columns.
	]. 

	^ SpBoxLayout newTopToBottom spacing: 5;
		add: text expand: false;
		add: table;
		yourself
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModel: aCollectionOfPairs [

	attributes := aCollectionOfPairs.
	self updatePresenter
]

{ #category : 'accessing - model' }
LDAPAttributePresenter >> setModelBeforeInitialization: aCollectionOfPairs [

	attributes := aCollectionOfPairs.
]

{ #category : 'api - actions' }
LDAPAttributePresenter >> statusFor: anEntry [

	^ false
]

{ #category : 'initialization' }
LDAPAttributePresenter >> updatePresenter [
 
	table items: attributes
]
