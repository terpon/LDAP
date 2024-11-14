"
I am a construct BERElement created when the decoder finds an unknown tag with the the constructed flag.
"
Class {
	#name : 'BERUnknownConstruct',
	#superclass : 'BERConstruct',
	#instVars : [
		'tag'
	],
	#category : 'LDAP-BER',
	#package : 'LDAP',
	#tag : 'BER'
}

{ #category : 'accessing' }
BERUnknownConstruct >> tag: anInteger [
	tag := anInteger 
]

{ #category : 'accessing' }
BERUnknownConstruct >> tagValue [ 
	^ tag
]
