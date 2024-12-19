"
I am a presenter to display BER elements as trees in the inspector.
"
Class {
	#name : 'LDAPEntryPresenter',
	#superclass : 'SpPresenterWithModel',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'table',
		'name',
		'initialized'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
LDAPEntryPresenter class >> currentApplication [ 
	^ LDAPBrowser new
]

{ #category : 'examples' }
LDAPEntryPresenter class >> example [
	| result |
	result := self sampleEntry.
	"result inspect."
	^ self show: result
]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleElement [
"Sample search result"
	| entry list |
	entry := LDAPSearchResultEntry new.
	entry addElement: (LDAPString new content: 'cn=hup,ou=people,dc=example,dc=com').
	list := LDAPPartialAttributeList new attributes: {
				 'objectClass' -> {'person'}.
				 'cn' -> {'hup'}.
				 'sn' -> {'hop'.'hip'.'hap'}.
				 'description' -> {'chömp'}
			}; yourself.
	entry addElement: list.
	^ entry

]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleEntry [
	| single sub entry |
	single := self sampleElement.
	sub := self sampleSubList.
	
	entry := LDAPEntryModel new name: single name.
	entry populateFromPartialAttributeList: single.
	entry populateFromResults: sub.
	^ entry
]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleSubList [
^ {
	  LDAPSearchResultEntry new addAll: { (LDAPString new content: 'cn=qux1,cn=bar55,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (LDAPString new content: 'objectClass'). (BERSet new addElement: (LDAPString new content: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (LDAPString new content: 'cn'). (BERSet new addElement: (LDAPString new content: 'qux1')) }; yourself). }; yourself) }; yourself.
	LDAPSearchResultEntry new addAll: { (LDAPString new content: 'cn=qux2,cn=bar55,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (LDAPString new content: 'objectClass'). (BERSet new addElement: (LDAPString new content: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (LDAPString new content: 'cn'). (BERSet new addElement: (LDAPString new content: 'qux2')) }; yourself). }; yourself) }; yourself.
	LDAPSearchResultEntry new addAll: { (LDAPString new content: 'cn=qux3,cn=bar56,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (LDAPString new content: 'objectClass'). (BERSet new addElement: (LDAPString new content: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (LDAPString new content: 'cn'). (BERSet new addElement: (LDAPString new content: 'qux3')) }; yourself). }; yourself) }; yourself
	}
]

{ #category : 'opening' }
LDAPEntryPresenter class >> show: anEntry [
	| model |
	(anEntry isKindOf: LDAPEntryModel) ifTrue: [ ^ (self on: anEntry) open ].
	
	model := LDAPEntryModel new name: 'dc=example,dc=com'.
	
	(anEntry isKindOf: LDAPSearchResultEntry) ifTrue: [ 
		model populateFromPartialAttributeList: anEntry.
		model name: anEntry name.
	].

	(anEntry isCollection) ifTrue: [ 
		model populateFromResults: anEntry.
	].

	^ (self on: model) open

]

{ #category : 'activation' }
LDAPEntryPresenter >> activate [
	"Perform here the activation."
	| dn anItem |
	self activationAction ifNil: [ ^ self ].
	
	anItem := self selectedItem.
	anItem isLeaf ifTrue: [ ^ self ].
	
	dn := String streamContents: [ :out |
		out nextPutAll: anItem name; nextPut:  $,; nextPutAll: self model name
	].
	self activationAction cull: (SpActivatedSelection newValue: dn)
]

{ #category : 'private' }
LDAPEntryPresenter >> colorFor: anAttribute [

	^ anAttribute isKey ifTrue: [ application emphasisColor ] ifFalse: [ application defaultColor ]
]

{ #category : 'initialization' }
LDAPEntryPresenter >> connectPresenters [ 

	super connectPresenters.
	
	table outputActivationPort transmitDo: [ self activate ].
]

{ #category : 'layout' }
LDAPEntryPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: name expand: false;
		add: table;
		yourself
]

{ #category : 'defaults' }
LDAPEntryPresenter >> iconFor: anAttribute [

	^ self iconNamed: (anAttribute isLeaf ifTrue: [ #blank ] ifFalse: [ #smallOpen ])
]

{ #category : 'initialization' }
LDAPEntryPresenter >> initializePresenters [ 

	name := self newTextInput beNotEditable;
		actions: (SpActionGroup new
			addActionWith: [ :anItem | anItem
				name: 'Copy';
				iconNamed: #smallCopy;
				shortcutKey: $c ctrl;
				description: 'Copy DN to clipboard';
				action: [ Clipboard clipboardText: name text informing: ('DN {1} copied to clipboard' format: {name text}) ] ]);
		yourself.

	table := self newTable activateOnSingleClick; 	alternateRowsColor;
		isResizable: true;
		addColumn: (SpCompositeTableColumn new title: 'Attribute';
			addColumn: (SpImageTableColumn new
				evaluated: [ :i | self iconFor: i ];
				yourself);
			addColumn: (SpStringTableColumn new
				displayColor: [ :i | self colorFor: i ];
				evaluated: [ :i | i description ];
				yourself));
		addColumn: (SpStringTableColumn new title: 'Value'; 
			displayColor: [ :i | self colorFor: i ];
			evaluated: [ :each | each content ]);
		yourself.

	"Model can be updated from other process before this is called"
	initialized := true.
]

{ #category : 'initialization' }
LDAPEntryPresenter >> initializeWindow: aSpWindowPresenter [

	| title |
	super initializeWindow: aSpWindowPresenter.

	title := self model ifNil: [ self className ] ifNotNil: [ :model | model className ].
	aSpWindowPresenter title: title.
]

{ #category : 'initialization' }
LDAPEntryPresenter >> modelChanged [ 
	
	| model dn |
	initialized ifNil: [ ^ self ].
	model := self model ifNil: [ ^ self reset ].
	
	table items: model attributes.
	
	dn := application formattedTextFor: model name.
	name text: dn; help: dn.

]

{ #category : 'initialization' }
LDAPEntryPresenter >> reset [

	initialized ifNil: [ ^ self ].
	table items: #().
	name text: ''; help: ''.

]

{ #category : 'accessing' }
LDAPEntryPresenter >> selectedItem [
	"Return selected item."
	
	^ table selectedItem
]
