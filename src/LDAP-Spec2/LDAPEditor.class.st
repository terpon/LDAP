"
I add edition commands to the LDAP browser.
"
Class {
	#name : 'LDAPEditor',
	#superclass : 'LDAPBrowser',
	#category : 'LDAP-Spec2-Applications',
	#package : 'LDAP-Spec2',
	#tag : 'Applications'
}

{ #category : 'instance creation' }
LDAPEditor class >> mainPresenterClass [

	^ LDAPEditorPresenter
]

{ #category : 'searching' }
LDAPEditor >> invalidateName: aDN [
"Gets entry from the cache and invalidate it"
	| aCachedEntry |
	aCachedEntry := cache at: aDN.
	aCachedEntry invalidate.
	self isConnected ifTrue: [ aCachedEntry update: self ].
]

{ #category : 'searching' }
LDAPEditor >> invalidateParent: aDN [
"Gets entry from the cache and invalidate it"
	| parentDN |
	parentDN := LDAPString parentOf: aDN.
	self invalidateName: parentDN
]

{ #category : 'accessing' }
LDAPEditor >> subSchema [

	^ session subSchema
]
