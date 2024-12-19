Class {
	#name : 'LDAPNameTest',
	#superclass : 'TestCase',
	#category : 'LDAP-Tests-Tests',
	#package : 'LDAP-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
LDAPNameTest >> testSplitInThird [

	self assert: (LDAPName splitInThird: 'a=a,b=b,c=c' root: 'c=c') equals: #('a=a' 'b=b' 'c=c').
	self assert: (LDAPName splitInThird: 'a=a,b=d,b=b,c=c' root: 'c=c') equals: #('a=a' 'b=d,b=b' 'c=c').
	
	self assert: (LDAPName splitInThird: 'c=c' root: 'c=c') equals: #('c=c' '' '').
	self assert: (LDAPName splitInThird: 'c=c' root: '') equals: #('c=c' '' '').

	self assert: (LDAPName splitInThird: 'a=a,b=b,c=c' root: 'z=z') equals: #('a=a' 'b=b,c=c' '').

]

{ #category : 'tests' }
LDAPNameTest >> testSplitOnFirstName [

	self assert: (LDAPName splitOnFirstName: 'a=a,b=b') equals: #('a=a' 'b=b').
	self assert: (LDAPName splitOnFirstName: 'a=a,b=b,c=c') equals: #('a=a' 'b=b,c=c').
	self assert: (LDAPName splitOnFirstName: 'a=a,b=d,b=b,c=c') equals: #('a=a' 'b=d,b=b,c=c').
	
	self assert: (LDAPName splitOnFirstName: 'c=c') equals: #('c=c' '').

]

{ #category : 'tests' }
LDAPNameTest >> testStripBase [

	| name |
	name := LDAPString new content: 'o=a'.
	self assert: (name stripBase: 'o=c,o=b,o=a') equals: 'o=c,o=b'.
	self assert: (name stripBase: 'o=b,o=a') equals: 'o=b'.
	self assert: (name stripBase: 'o=a') equals: ''.
	self assert: (name stripBase: 'o=b') equals: 'o=b'.
	self assert: (name stripBase: 'o=b+o=a') equals: 'o=b+o=a'.

]
