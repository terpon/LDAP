"
I am a request used to determine whether a given entry has a specified attribute value.

I can be replaced by a `LDAPSearchRequest` with a scope of baseObject, and an equality filter. When the attribute matches, there will be an extra search result entry message.
"
Class {
	#name : 'LDAPCompareRequest',
	#superclass : 'BERSequence',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'accessing' }
LDAPCompareRequest class >> tagValue [
	^ 16r6E "Application 14"
]

{ #category : 'accessing' }
LDAPCompareRequest >> comparing: aFilter [
	elements at: 2 put: aFilter
]

{ #category : 'initialization' }
LDAPCompareRequest >> initialize [ 
	super initialize.
	
	self addElement: (LDAPString new). "entry"
	self addElement: (LDAPFilterEquality new). "AttributeValueAssertion"

]

{ #category : 'accessing' }
LDAPCompareRequest >> name: aString [
	elements first content: aString
]
