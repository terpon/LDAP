"
I represent attribute syntaxes
"
Class {
	#name : 'LDAPSyntax',
	#superclass : 'LDAPObject',
	#instVars : [
		'notHumanReadable',
		'binaryTransferRequired'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'default values' }
LDAPSyntax class >> defaultObjects [
"This is taken from standard intallation of OpenLDAP server"
	^ #( '( 1.3.6.1.4.1.1466.115.121.1.4 DESC ''Audio'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.5 DESC ''Binary'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.6 DESC ''Bit String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.7 DESC ''Boolean'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.8 DESC ''Certificate'' X-BINARY-TRANSFER-REQUIRED ''TRUE'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.9 DESC ''Certificate List'' X-BINARY-TRANSFER-REQUIRED ''TRUE'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.10 DESC ''Certificate Pair'' X-BINARY-TRANSFER-REQUIRED ''TRUE'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.4203.666.11.10.2.1 DESC ''X.509 AttributeCertificate'' X-BINARY-TRANSFER-REQUIRED ''TRUE'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.12 DESC ''Distinguished Name'' )'
	     '( 1.2.36.79672281.1.5.0 DESC ''RDN'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.14 DESC ''Delivery Method'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.15 DESC ''Directory String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.22 DESC ''Facsimile Telephone Number'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.24 DESC ''Generalized Time'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.26 DESC ''IA5 String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.27 DESC ''Integer'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.28 DESC ''JPEG'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.34 DESC ''Name And Optional UID'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.36 DESC ''Numeric String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.38 DESC ''OID'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.39 DESC ''Other Mailbox'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.40 DESC ''Octet String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.41 DESC ''Postal Address'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.44 DESC ''Printable String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.11 DESC ''Country String'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.45 DESC ''SubtreeSpecification'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.49 DESC ''Supported Algorithm'' X-BINARY-TRANSFER-REQUIRED ''TRUE'' X-NOT-HUMAN-READABLE ''TRUE'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.50 DESC ''Telephone Number'' )'
	     '( 1.3.6.1.4.1.1466.115.121.1.52 DESC ''Telex Number'' )'
	     '( 1.3.6.1.1.1.0.0 DESC ''RFC2307 NIS Netgroup Triple'' )'
	     '( 1.3.6.1.1.1.0.1 DESC ''RFC2307 Boot Parameter'' )'
	     '( 1.3.6.1.1.16.1 DESC ''UUID'' )'
	     '( 1.2.840.113549.1.8.1.1 DESC ''PKCS#8 PrivateKeyInfo'' )' )
]

{ #category : 'accessing' }
LDAPSyntax >> binaryTransferRequired: aBoolean [

	binaryTransferRequired := aBoolean
]

{ #category : 'testing' }
LDAPSyntax >> doesNotRequireBinaryTransfer [

	^ self requireBinaryTransfer not
]

{ #category : 'accessing - extension' }
LDAPSyntax >> extensions: aDictionary [

	self checkSupport: #( 'X-BINARY-TRANSFER-REQUIRED' 'X-NOT-HUMAN-READABLE' ) in: aDictionary.
	
	aDictionary at: 'X-BINARY-TRANSFER-REQUIRED' ifPresent: [ :value | value = 'TRUE' ifTrue: [ binaryTransferRequired := true ] ].
	aDictionary at: 'X-NOT-HUMAN-READABLE' ifPresent: [ :value | value = 'TRUE' ifTrue: [ notHumanReadable := true ] ].	
]

{ #category : 'testing' }
LDAPSyntax >> isHumanReadable [

	^ self isNotHumanReadable not
]

{ #category : 'testing' }
LDAPSyntax >> isNotHumanReadable [

	^ notHumanReadable ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPSyntax >> notHumanReadable: aBoolean [

	notHumanReadable := aBoolean 
]

{ #category : 'printing' }
LDAPSyntax >> printOn: aStream [

	aStream nextPutAll: 'a '; nextPutAll: self className; space.
	self description ifNotEmpty: [ :d | aStream nextPut: $'; nextPutAll: d; nextPut: $'; space ]. 
	aStream nextPut: $(; nextPutAll: oid; nextPut: $).
]

{ #category : 'testing' }
LDAPSyntax >> requireBinaryTransfer [

	^ binaryTransferRequired ifNil: [ false ]
]
