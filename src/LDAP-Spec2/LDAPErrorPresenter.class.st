Class {
	#name : 'LDAPErrorPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'current',
		'result',
		'next',
		'previous',
		'clear',
		'clearAll',
		'close',
		'serverName',
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
		add: result;
		add: self buttonsLayout expand: false;
		yourself
]

{ #category : 'initialization' }
LDAPErrorPresenter >> initializePresenters [ 

	previous := self newButton disable;
				  			icon: (self iconNamed: #back);
				     		help: 'See previous error';
				       	action: [ self previous ];
				        	yourself.
	next := self newButton disable;
				  			icon: (self iconNamed: #forward);
				     		help: 'See next error';
				       	action: [ self next ];
				        	yourself.
	position := self newLabel label: '0/0'; yourself.
	result := self instantiate: LDAPResultPresenter.
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

	serverName ifNotNil: [ :name | 
		aSpWindowPresenter title: (String streamContents: [ :stream | 
			stream nextPutAll: 'Errors from '; nextPutAll: name ])
		].
	aSpWindowPresenter whenOpenedDo: [ clear takeKeyboardFocus ].
]

{ #category : 'initialization' }
LDAPErrorPresenter >> modelChanged [ 

	| count |
	count := self model ifNil: [ 0 ] ifNotNil: [ :model | model size ].
	current := self current min: count max: 1.
	result result: (count isZero 
		ifTrue: [ current := 0. nil ]
		ifFalse: [ self model at: current ]).

	position label: (String streamContents: [:s| s << current asString << $/ << count asString ]).
	previous enabled: current > 1.
	next enabled: (current > 0) & (current < count).
	
	^ self
]

{ #category : 'layout' }
LDAPErrorPresenter >> navigationLayout [ 
	^ SpBoxLayout newLeftToRight 
		spacing: 3;
		add: (SpBoxLayout newLeftToRight add: previous; yourself); 
		add: (SpBoxLayout newLeftToRight hAlignCenter; add: position; yourself);
		add: (SpBoxLayout newLeftToRight hAlignEnd; add: next; yourself);
		yourself
]

{ #category : 'api - events' }
LDAPErrorPresenter >> next [

	self model ifNil: [ ^ self ].
	current := current + 1.
	self modelChanged.
]

{ #category : 'api - events' }
LDAPErrorPresenter >> previous [

	self model ifNil: [ ^ self ].
	current := current - 1.
	self modelChanged.
]

{ #category : 'api - events' }
LDAPErrorPresenter >> removeAll [

	self model ifNil: [ ^ self ].
	self model removeAll.
]

{ #category : 'api - events' }
LDAPErrorPresenter >> removeCurrent [
	
	| model |
	model := self model ifNil: [ ^ self ].
	(current = 0) ifTrue: [ ^ self modelChanged ].
	(current <= model size) ifFalse: [ ^ self modelChanged ].
	model removeAt: current.
]

{ #category : 'accessing' }
LDAPErrorPresenter >> serverName: anObject [

	serverName := anObject
]
