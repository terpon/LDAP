Class {
	#name : 'LDAPObjectClassParser',
	#superclass : 'LDAPObjectClassGrammar',
	#category : 'LDAP-Schema-Parsers',
	#package : 'LDAP-Schema',
	#tag : 'Parsers'
}

{ #category : 'accessing' }
LDAPObjectClassParser class >> ignoredNames [ 

	^ super ignoredNames copyWith: #result
]

{ #category : 'accessing' }
LDAPObjectClassParser >> objectClass [

	^ super objectClass map: [ :_oid :_names :_desc :_obsolete :_sup :_kind :_must :_may :_extensions |
		LDAPObjectClass new oid: _oid;
			names: _names;
			description: _desc;
			obsolete: _obsolete;
			superiors: _sup;
			kind: _kind;
			must: _must;
			may: _may;
			extensions: _extensions asArray;
			yourself
	]
]

{ #category : 'accessing' }
LDAPObjectClassParser >> obsolete [ 

	^ super obsolete map: [ :o | true ]
]
