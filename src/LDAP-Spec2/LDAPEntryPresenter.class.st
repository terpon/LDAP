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
		'name'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'examples' }
LDAPEntryPresenter class >> example [
	| result |
	result := LDAPEntryModel new name: 'dc=example,dc=com'.
	result populateFromResults: self sampleList.
	result populateFromPartialAttributeList: self sampleElement.
	"result inspect."
	^ self show: result

]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleElement [
"Sample search result"
	| entry list |
	entry := LDAPSearchResultEntry new.
	entry addElement: (BEROctetString new value: 'cn=test4,dc=example,dc=com').
	list := LDAPPartialAttributeList new addAll: { 
				LDAPPartialAttribute new description: 'objectClass'; values: 'person'; yourself.
				LDAPPartialAttribute new description: 'cn'; values: 'Haddock'; yourself.
				LDAPPartialAttribute new description: 'sn'; values: { 'Haddock'. 'Capitaine' }; yourself 
			 }; yourself.
	entry addElement: list.
	^ entry

]

{ #category : 'examples' }
LDAPEntryPresenter class >> sampleList [
^ {
	  LDAPSearchResultEntry new addAll: { (BEROctetString new value: 'cn=qux1,cn=bar55,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'objectClass'). (BERSet new addElement: (BEROctetString new value: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'cn'). (BERSet new addElement: (BEROctetString new value: 'qux1')) }; yourself). }; yourself) }; yourself.
	LDAPSearchResultEntry new addAll: { (BEROctetString new value: 'cn=qux2,cn=bar55,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'objectClass'). (BERSet new addElement: (BEROctetString new value: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'cn'). (BERSet new addElement: (BEROctetString new value: 'qux2')) }; yourself). }; yourself) }; yourself.
	LDAPSearchResultEntry new addAll: { (BEROctetString new value: 'cn=qux3,cn=bar56,dc=example,dc=com'). (LDAPPartialAttributeList new addAll: { (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'objectClass'). (BERSet new addElement: (BEROctetString new value: 'person')) }; yourself). (LDAPPartialAttribute new addAll: { (BEROctetString new value: 'cn'). (BERSet new addElement: (BEROctetString new value: 'qux3')) }; yourself). }; yourself) }; yourself
	}
]

{ #category : 'opening' }
LDAPEntryPresenter class >> show: anEntry [
	| presenter |
	presenter := self on: anEntry.
	^ presenter open

]

{ #category : 'activation' }
LDAPEntryPresenter >> activate: anItem [
	"Perform here the activation."
	
	self activationAction ifNil: [ ^ self ].
	anItem isLeaf ifTrue: [ ^ self ].
	
	self activationAction cull: (SpActivatedSelection newValue: anItem)

]

{ #category : 'api' }
LDAPEntryPresenter >> activateOnDoubleClick [

	table activateOnDoubleClick
]

{ #category : 'api' }
LDAPEntryPresenter >> activateOnSingleClick [

	table activateOnSingleClick
]

{ #category : 'initialization' }
LDAPEntryPresenter >> connectPresenters [ 

	super connectPresenters.
	
	table whenActivatedDo: [ :selection | self activate: selection selectedItem ].

]

{ #category : 'layout' }
LDAPEntryPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		add: name expand: false;
		add: table;
		yourself
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

	table := self newTable
		isResizable: true;
		alternateRowsColor;
		addColumn: (SpCompositeTableColumn new
			title: 'Attribute';
			addColumn: (SpImageTableColumn new
			width: 20;
			evaluated: [ :i | i icon: self application ];
			yourself);
		addColumn: (SpStringTableColumn new
			evaluated: [ :i | i description ];
			yourself));
	addColumn: (SpStringTableColumn new
		title: 'Value'; 
		evaluated: [ :each | each value ]);
	yourself.
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
	
	| model |
	model := self model ifNil: [ ^ self reset ].
	
	table items: model attributes.
	name text: model name; help: model name.

]

{ #category : 'ports' }
LDAPEntryPresenter >> outputActivationPort [ 
	^ table outputActivationPort
]

{ #category : 'initialization' }
LDAPEntryPresenter >> reset [

	table items: #().
	name label: ''.

]

{ #category : 'accessing' }
LDAPEntryPresenter >> selectedItem [
	"Return selected item."
	
	^ table selectedItem
]
