"
I am a status bar presenter with connection status, last error message.
"
Class {
	#name : 'LDAPStatusBarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'connected',
		'message',
		'disconnect',
		'disconnectAction'
	],
	#category : 'LDAP-Spec2-Presenters',
	#package : 'LDAP-Spec2',
	#tag : 'Presenters'
}

{ #category : 'api - events' }
LDAPStatusBarPresenter >> beConnected [

	connected image: (self iconNamed: #testGreen).
	
	connected help: 'Connected'. 
	"Does not update help with morphic"	
	connected withAdapterDo: [ :anAdapter | anAdapter setBalloonText: 'Connected' ]
]

{ #category : 'api - events' }
LDAPStatusBarPresenter >> beDisconnected [

	connected image: (self iconNamed: #testNotRun).
	
	connected help: 'Disconnected'. 
	"Does not update help with morphic"	
	connected withAdapterDo: [ :anAdapter | anAdapter setBalloonText: 'Disconnected' ]
]

{ #category : 'accessing' }
LDAPStatusBarPresenter >> connected: aBoolean [

	aBoolean ifTrue: [ self beConnected ] ifFalse: [ self beDisconnected ]
]

{ #category : 'layout' }
LDAPStatusBarPresenter >> defaultLayout [ 
	^ SpBoxLayout newLeftToRight 
		spacing: 3; vAlignCenter;
		add: #connected expand: false;
		add: #message;
		add: #disconnect expand: false;
		yourself
]

{ #category : 'private - events' }
LDAPStatusBarPresenter >> disconnectAction [

	disconnectAction ifNotNil: [ :block | block cull: self ].
]

{ #category : 'api' }
LDAPStatusBarPresenter >> display: aString [

	message text: (aString ifNil: [''])
]

{ #category : 'initialization' }
LDAPStatusBarPresenter >> initializePresenters [ 

	connected := self newImage 
		image: (self iconNamed: #testNotRun);
		help: 'Disconnected'.
		
	message := self newTextInput beNotEditable.

	disconnect := 	self newToolbar beIcons;
		add: (self newToolbarButton 
			label: 'disconnect';
  			icon: (self iconNamed: #smallQuit);
     		help: 'Disconnect from current server';
       	action: [ self disconnectAction ];
        	yourself); yourself.
]

{ #category : 'api - events' }
LDAPStatusBarPresenter >> onDisconnectDo: aBlock [

	disconnectAction := aBlock.
]
