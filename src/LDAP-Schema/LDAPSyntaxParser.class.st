"
I am a parser that create attribute syntaxes objects
"
Class {
	#name : 'LDAPSyntaxParser',
	#superclass : 'LDAPSyntaxGrammar',
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'accessing' }
LDAPSyntaxParser >> syntax [
	
	^ super syntax map: [ :_oid :_desc :_extensions |
		LDAPSyntax new oid: _oid;
			description: _desc;
			extensions: _extensions;
			yourself
	]
]
