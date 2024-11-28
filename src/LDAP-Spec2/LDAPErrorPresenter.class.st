"
I am a presenter to display LDAP errors from the server
"
Class {
	#name : 'LDAPErrorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'toolbar',
		'inspect',
		'shown',
		'next',
		'previous',
		'clear',
		'clearAll',
		'position'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'specs' }
LDAPErrorPresenter class >> title [

	^ 'LDAP errors'
]

{ #category : 'layout' }
LDAPErrorPresenter >> buttonsLayout [

	| left right |
	left := SpBoxLayout newLeftToRight spacing: 5;
		add: clear expand: false;
		add: toolbar expand: false;
		yourself.
	right := SpBoxLayout newLeftToRight hAlignEnd;
		add: clearAll expand: false;
		yourself.
	^ SpBoxLayout newLeftToRight add: left; add: right; yourself
]

{ #category : 'layout' }
LDAPErrorPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: self navigationLayout expand: false;
		add: shown layout: #fullLayout;
		add: self buttonsLayout expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPErrorPresenter >> initializePresenters [ 

	previous := self newButton
				  			icon: (self iconNamed: #back);
				     		help: 'See previous error';
				       	action: [ self previous ];
				        	yourself.
	next := self newButton
				  			icon: (self iconNamed: #forward);
				     		help: 'See next error';
				       	action: [ self next ];
				        	yourself.
	position := self newLabel label: '0/0'; yourself.
	shown := self instantiate: LDAPResultPresenter.
	clear := self newButton label: 'Clear';
				     		help: 'Remove current error from the queue';
				       	action: [ self removeCurrent ];
				        	yourself.
	clearAll := self newButton label: 'Clear all';
				  			icon: (self iconNamed: #cancel);
				     		help: 'Remove all errors and close window';
				       	action: [ self removeAll ];
				        	yourself.
	inspect := self newToolbarButton disable;
							label: 'Inspect';
				  			icon: (self iconNamed: #inspect);
				     		help: 'Inspect current command';
				       	action: [ self inspectCurrent ];
				        	yourself.
	toolbar := self newToolbar beIcons; add: inspect; yourself.

]

{ #category : 'initialization' }
LDAPErrorPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	application connectedServer ifNotNil: [ :server |
		aSpWindowPresenter title: (String streamContents: [ :stream | 
			stream nextPutAll: 'Errors from '; nextPutAll: server ])
		]. 

	aSpWindowPresenter whenOpenedDo: [ clear takeKeyboardFocus ].
]

{ #category : 'api - events' }
LDAPErrorPresenter >> inspectCurrent [
	
	self model ifNotNil: [ :model | model currentCommand ifNotNil: [ :command | command message inspect ] ]
]

{ #category : 'initialization' }
LDAPErrorPresenter >> modelChanged [ 

	| model current count index |
	model := self model ifNil: [ ^ self reset ].
	current := model current.
	index := current first.
	count := current second.
	index = 0 ifTrue: [ self reset. ^ self withWindowDo: [ :window | window close ] ].

	position label: ('{1}/{2}' format: { index. count }).
	shown result: (self resultFrom: current third).

	inspect enabled: current third isNotNil.
	previous enabled: index > 1.
	next enabled: (index > 0) & (index < count).

]

{ #category : 'layout' }
LDAPErrorPresenter >> navigationLayout [ 
	^ SpBoxLayout newLeftToRight 
		spacing: 3;
		add: (SpBoxLayout newLeftToRight add: previous; yourself) expand: false; 
		add: (SpBoxLayout newLeftToRight hAlignCenter; vAlignCenter;
			"add: guilll;" 
			add: position expand: false; 
			"add: max; "
			yourself);
		add: (SpBoxLayout newLeftToRight hAlignEnd; add: next; yourself) expand: false;
		yourself
]

{ #category : 'api - events' }
LDAPErrorPresenter >> next [

	self model ifNotNil: [ :model | model next ].

]

{ #category : 'api - events' }
LDAPErrorPresenter >> previous [

	self model ifNotNil: [ :model | model previous ].

]

{ #category : 'api - events' }
LDAPErrorPresenter >> removeAll [

	self model ifNotNil: [ :model | model removeAll ].

]

{ #category : 'api - events' }
LDAPErrorPresenter >> removeCurrent [
	
	self model ifNotNil: [ :model | model removeCurrent ].

]

{ #category : 'initialization' }
LDAPErrorPresenter >> reset [ 

	position label: ''.
	shown result: nil.

	previous disable.
	next disable.
	inspect disable.

]

{ #category : 'converting' }
LDAPErrorPresenter >> resultFrom: aCommand [
	
	| responses |
	aCommand ifNil: [ ^ LDAPResult newCode: 80 name: '' message: 'Connection returned a nil LDAPCommand' ].
	responses := aCommand responses ifEmpty: [ ^ LDAPResult newCode: 80 name: '' message: 'No responses in LDAPCommand'].
	^ responses last
]
