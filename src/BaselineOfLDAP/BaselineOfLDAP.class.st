"
LDAP (Lightweight Directory Access Protocol) is a network protocol for remote directories. 

This implementation is fully written in Pharo and don't requires access to native libraries.
"
Class {
	#name : 'BaselineOfLDAP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfLDAP',
	#package : 'BaselineOfLDAP'
}

{ #category : 'baselines' }
BaselineOfLDAP >> baseline: spec [
	<baseline>
	spec
		for: #common
			do: [
				"Dependencies"
				self petitParser2: spec.

				self packages:  spec.
				self groups: spec.
			]
]

{ #category : 'accessing' }
BaselineOfLDAP >> groups: spec [
	"groups"
	spec
		group: 'Core' with: #('LDAP' );
		group: 'AD' with: #('LDAP-ActiveDirectory');
		group: 'Schema' with: #('LDAP-Schema');
		group: 'UI' with: #('LDAP-Spec2');
		group: 'Tests' with: #('LDAP-Tests' 'LDAP-Schema-Tests' 'LDAP-UI-Tests');
		group: 'All' with: #('Core' 'AD' 'UI' 'Schema' 'Tests').
		
	"aliases"
	spec 
		group: 'all' with: #('All');
		group: 'default' with: #('Core')
]

{ #category : 'accessing' }
BaselineOfLDAP >> packages: spec [
	"Packages"
	spec
		package: 'LDAP';
		package: 'LDAP-Schema' with: [ spec requires: #('LDAP' 'PetitParser2Core') ];
		package: 'LDAP-Spec2' with: [ spec requires: #('LDAP' 'LDAP-Schema') ];
		package: 'LDAP-ActiveDirectory' with: [ spec requires: #('LDAP') ];
		
		"Tests"
		package: 'LDAP-Tests' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-Schema-Tests' with: [ spec requires: #('LDAP-Schema') ];
		package: 'LDAP-UI-Tests' with: [ spec requires: #('LDAP-Spec2') ]
]

{ #category : 'dependencies' }
BaselineOfLDAP >> petitParser2: spec [
	spec
		baseline: 'PetitParser2Core'
		with: [
			spec  
				repository: 'github://kursjan/petitparser2'
		]
]
