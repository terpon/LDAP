Class {
	#name : 'LDAPErrorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'current',
		'slash',
		'max',
		'shown',
		'next',
		'previous',
		'clear',
		'clearAll',
		'close'
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
		add: clearAll expand: false;
		yourself.
	right := SpBoxLayout newLeftToRight hAlignEnd;
		add: close expand: false;
		yourself.
	^ SpBoxLayout newLeftToRight add: left; add: right; yourself
]

{ #category : 'accessing' }
LDAPErrorPresenter >> current [

	^ current ifNil: [ 0 ]
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
	current := self newNumberInput beNotEditable; yourself.
	slash := self newLabel label: '/'; yourself.
	max := self newNumberInput beNotEditable; yourself.
	shown := self instantiate: LDAPResultPresenter.
	clear := self newButton label: 'Clear';
				     		help: 'Remove current error from the queue';
				       	action: [ self removeCurrent ];
				        	yourself.
	clearAll := self newButton label: 'Clear all';
				  			icon: (self iconNamed: #cancel);
				     		help: 'Remove all errors';
				       	action: [ self removeAll ];
				        	yourself.
	close := self newButton label: 'Close';
				  			icon: (self iconNamed: #close);
				     		help: 'Remove all errors';
				       	action: [ self withWindowDo: [ :w | w close ] ];
				        	yourself.

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

{ #category : 'initialization' }
LDAPErrorPresenter >> modelChanged [ 

	| model count index |
	model := self model ifNil: [ ^ self reset ].
	index := model current.
	count := model size.

	current number: index.
	max number: count.
	slash label: (String streamContents: [:s | s nextPutAll: index asString; nextPut: $/; nextPutAll: count asString ]).
	shown result: (count isZero 
		ifTrue: [ nil ]
		ifFalse: [ model currentResult ]).

	previous enabled: index > 1.
	next enabled: (index > 0) & (index < count).

]

{ #category : 'layout' }
LDAPErrorPresenter >> navigationLayout [ 
	^ SpBoxLayout newLeftToRight 
		spacing: 3;
		add: (SpBoxLayout newLeftToRight add: previous; yourself) expand: false; 
		add: (SpBoxLayout newLeftToRight hAlignCenter; vAlignCenter;
			"add: current;" 
			add: slash expand: false; 
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

	current number: 0.
	max number: 0.
	shown result: nil.

	previous disable.
	next disable.

]
