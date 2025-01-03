"
I am a presenter to edit attributes.
"
Class {
	#name : 'LDAPAttributeLineSorter',
	#superclass : 'Object',
	#instVars : [
		'attributes',
		'knownClasses',
		'otherClasses',
		'mustAttributes',
		'mayAttributes',
		'otherAttributes',
		'schema'
	],
	#category : 'LDAP-Spec2-Attributes',
	#package : 'LDAP-Spec2',
	#tag : 'Attributes'
}

{ #category : 'updating - widgets' }
LDAPAttributeLineSorter >> attributeLines: aDictionary as: aClass on: aStream [
	
	aDictionary keysAndValuesDo: [ :anAttribute :aCollection | 
		aCollection 
			ifEmpty: [ aStream nextPut: (aClass empty: anAttribute) ] 
			ifNotEmpty: [ | canBeDeleted |
				canBeDeleted := (aCollection size > 1) or: [ aClass canDeleteLast ].
				aCollection do: [ :each | aStream nextPut: (aClass new attribute: each; canDelete: canBeDeleted) ] ] 
	]
]

{ #category : 'accessing - model' }
LDAPAttributeLineSorter >> attributes: aCollection [

 	| ocs |
	attributes := Dictionary new.
	aCollection do: [ :anAttribute |
		attributes at: anAttribute description asLowercase 
			update: [ :values | values add: anAttribute; yourself ] 
			initial: [ OrderedCollection with: anAttribute ].
	].

	ocs := attributes removeKey: 'objectclass' ifAbsent: [ #() ].
	self updateObjectClasses: ocs.
	self updateKnownAttributes: attributes from: mustAttributes.
	self updateKnownAttributes: attributes from: mayAttributes.
	otherAttributes := attributes values flattened.
]

{ #category : 'testing' }
LDAPAttributeLineSorter >> hasObjectClasses [

	^ knownClasses isNotEmpty or: [ otherClasses isNotEmpty ]
]

{ #category : 'initialization' }
LDAPAttributeLineSorter >> lines [
	^ OrderedCollection streamContents: [ :out |
		self objectClassLinesOn: out.
		self mustLinesOn: out.
		self mayLinesOn: out.
		otherAttributes do: [ :each | out nextPut: (LDAPCustomAttributeTableLine new attribute: each) ].
		out nextPut: LDAPEmptyAttributeTableLine new
	]
]

{ #category : 'updating - widgets' }
LDAPAttributeLineSorter >> mayLinesOn: aStream [
	
	| types |
	types := mayAttributes keys sorted asOrderedCollection.
	(mayAttributes reject: #isEmpty) keysAndValuesDo: [ :aDescription :aCollection |
		types remove: aDescription.
		aCollection do: [ :each | aStream nextPut: (LDAPAllowedAttributeTableLine new attribute: each; beDeletable) ] 
	].
	types do: [ :aDescription | aStream nextPut: (LDAPAllowedAttributeTableLine empty: aDescription) ].
]

{ #category : 'updating - widgets' }
LDAPAttributeLineSorter >> mustLinesOn: aStream [
	
	| types |
	types := mustAttributes keys sorted.
	types do: [ :aDescription | | aCollection |
		aCollection := mustAttributes at: aDescription.
		aCollection 
			ifEmpty: [ aStream nextPut: (LDAPRequiredAttributeTableLine empty: aDescription) ] 
			ifNotEmpty: [ | canBeDeleted |
				canBeDeleted := aCollection size > 1.
				aCollection do: [ :each | aStream nextPut: (LDAPRequiredAttributeTableLine new attribute: each; canDelete: canBeDeleted) ] ] 
	]
]

{ #category : 'updating - widgets' }
LDAPAttributeLineSorter >> objectClassLinesOn: aStream [
	
	knownClasses do: [ :oc | aStream nextPut: (LDAPObjectClassTableLine new objectClass: oc) ]. 
	otherClasses do: [ :oc | aStream nextPut: (LDAPObjectClassTableLine unknown: oc) ].

	self hasObjectClasses ifFalse: [ 	aStream nextPut: LDAPObjectClassTableLine new ].
]

{ #category : 'accessing' }
LDAPAttributeLineSorter >> schema [

	^ schema ifNil: [ LDAPSchema default ]
]

{ #category : 'accessing' }
LDAPAttributeLineSorter >> schema: anObject [

	schema := anObject
]

{ #category : 'updating' }
LDAPAttributeLineSorter >> updateKnownAttributes: aCollection [

	| knownAttributes |
	knownAttributes := LDAPObjectClass attributesFrom: aCollection.
	mustAttributes := Dictionary newFrom: (knownAttributes first collect: [ :attribute | attribute -> OrderedCollection new ]).
	mayAttributes := Dictionary newFrom: (knownAttributes second collect: [ :attribute | attribute -> OrderedCollection new ]).
]

{ #category : 'updating' }
LDAPAttributeLineSorter >> updateKnownAttributes: aCollection from: anAttributeList [

	"In aCollection, an attribute can be found both at 'cn' and 'commonName'"
	anAttributeList keysAndValuesDo: [ :attribute :elements | attribute keysDo: [ :key |
			| collection |
			collection := aCollection removeKey: key asLowercase ifAbsent: [ #() ].
			elements addAll: collection
	] ]
]

{ #category : 'updating' }
LDAPAttributeLineSorter >> updateObjectClasses: aCollection [

	knownClasses := OrderedCollection new.
	otherClasses := OrderedCollection new.
	aCollection do: [ :oc | | name |
		name := oc content.
		self schema objectClass: name
			ifPresent: [ :class | knownClasses add: class ]
			ifAbsent: [ otherClasses add: name ] ].
	
	self updateKnownAttributes: knownClasses.
]
