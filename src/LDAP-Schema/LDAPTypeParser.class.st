"
I create LDAPAttributeType objects from LDAP server strings
"
Class {
	#name : 'LDAPTypeParser',
	#superclass : 'LDAPTypeGrammar',
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'grammar' }
LDAPTypeParser >> type [
	^ super type map: [ :_oid :_names :_desc :_ob :_sup :_eq :_or :_sub :_syn :_sv :_co :_noum :_usage :_ext |
		| result |
		result := LDAPAttributeType new oid: _oid;
			names: _names;
			description: _desc;
			obsolete: _ob;
			superior: _sup;
			equality: _eq;
			ordering: _or;
			substring: _sub;
			singleValue: _sv;
			collective: _co;
			noUserModification: _noum;
			usage: _usage;
			extensions: _ext.
		_syn ifNotNil: [ result syntax: _syn first; syntaxLength: _syn second ].
		result
	]
]
