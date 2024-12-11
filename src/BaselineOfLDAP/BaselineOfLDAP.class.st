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
				self packages:  spec.
				self groups: spec.
			]
]

{ #category : 'accessing' }
BaselineOfLDAP >> groups: spec [
	"groups"
	spec
		group: 'Core' with: #('LDAP' );
		group: 'AD' with: #('Core' 'LDAP-ActiveDirectory');
		group: 'Schema' with: #('Core' 'LDAP-Schema');
		group: 'UI' with: #('Core' 'LDAP-Spec2');
		group: 'Tests' with: #('LDAP-Tests' 'LDAP-Schema' 'LDAP-UI-Tests');
		group: 'All' with: #('Core' 'Tests' 'AD' 'UI' 'Schema') 
]

{ #category : 'accessing' }
BaselineOfLDAP >> packages: spec [
	"Packages"
	spec
		package: 'LDAP';
		package: 'LDAP-Schema' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-Spec2' with: [ spec requires: #('LDAP' 'LDAP-Schema') ];
		package: 'LDAP-ActiveDirectory' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-Tests' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-Schema-Tests' with: [ spec requires: #('LDAP-Schema') ];
		package: 'LDAP-UI-Tests' with: [ spec requires: #('LDAP-Spec2') ]
]
