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
		group: 'UI' with: #('Core' 'LDAP-Spec2');
		group: 'AD' with: #('Core' 'LDAP-SSL' 'LDAP-ActiveDirectory');
		group: 'Tests' with: #('Core' 'LDAP-Tests');
		group: 'All' with: #('Core' 'Tests' 'AD' 'UI' ) 
]

{ #category : 'accessing' }
BaselineOfLDAP >> packages: spec [
	"Packages"
	spec
		package: 'LDAP';
		package: 'LDAP-Spec2' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-Tests' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-SSL' with: [ spec requires: #('LDAP') ];
		package: 'LDAP-ActiveDirectory' with: [ spec requires: #('LDAP' 'LDAP-SSL') ]

]
