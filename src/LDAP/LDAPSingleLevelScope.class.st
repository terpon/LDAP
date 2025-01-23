"
I mean only the entries that are immediate subordinates to the baseObject entry will be considered.

The base entry itself will not be considered, nor will entries more than one level beneath the base entry.
"
Class {
	#name : 'LDAPSingleLevelScope',
	#superclass : 'LDAPSearchScope',
	#category : 'LDAP-Search',
	#package : 'LDAP',
	#tag : 'Search'
}

{ #category : 'initialization' }
LDAPSingleLevelScope >> initialize [ 
	super initialize.
	integer := 1. "single level"
]

{ #category : 'accessing' }
LDAPSingleLevelScope >> name [
	^ 'singleLevel'
]
