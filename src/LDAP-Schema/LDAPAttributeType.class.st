"
I represent an object class
"
Class {
	#name : 'LDAPAttributeType',
	#superclass : 'LDAPNamedObject',
	#instVars : [
		'superior',
		'equality',
		'ordering',
		'substr',
		'syntax',
		'syntaxLength',
		'usage',
		'ordered',
		'collective',
		'singleValue',
		'noUserModification',
		'hasOrderedValues',
		'hasOrderedSiblings'
	],
	#category : 'LDAP-Schema-Schema',
	#package : 'LDAP-Schema',
	#tag : 'Schema'
}

{ #category : 'default values' }
LDAPAttributeType class >> defaultObjects [
"This is a part of the response from a standard intallation of OpenLDAP server"
	^ #( '( 2.5.4.0 NAME ''objectClass'' DESC ''RFC4512: object classes of the entity'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 )'
	     '( 2.5.21.9 NAME ''structuralObjectClass'' DESC ''RFC4512: structural object class of entry'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.1 NAME ''createTimestamp'' DESC ''RFC4512: time which object was created'' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.2 NAME ''modifyTimestamp'' DESC ''RFC4512: time which object was last modified'' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.3 NAME ''creatorsName'' DESC ''RFC4512: name of creator'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.4 NAME ''modifiersName'' DESC ''RFC4512: name of last modifier'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.9 NAME ''hasSubordinates'' DESC ''X.501: entry has children'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 1.3.6.1.1.20 NAME ''entryDN'' DESC ''DN of the entry'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 1.3.6.1.1.16.4 NAME ''entryUUID'' DESC ''UUID of the entry'' EQUALITY UUIDMatch ORDERING UUIDOrderingMatch SYNTAX 1.3.6.1.1.16.1 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 1.3.6.1.4.1.4203.666.1.7 NAME ''entryCSN'' DESC ''change sequence number of the entry content'' EQUALITY CSNMatch ORDERING CSNOrderingMatch SYNTAX 1.3.6.1.4.1.4203.666.11.2.1{64} SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 1.3.6.1.4.1.4203.666.1.25 NAME ''contextCSN'' DESC ''the largest committed CSN of a context'' EQUALITY CSNMatch ORDERING CSNOrderingMatch SYNTAX 1.3.6.1.4.1.4203.666.11.2.1{64} NO-USER-MODIFICATION USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.6 NAME ''altServer'' DESC ''RFC4512: alternative servers'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.5 NAME ''namingContexts'' DESC ''RFC4512: naming contexts'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.13 NAME ''supportedControl'' DESC ''RFC4512: supported controls'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.7 NAME ''supportedExtension'' DESC ''RFC4512: supported extended operations'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.15 NAME ''supportedLDAPVersion'' DESC ''RFC4512: supported LDAP versions'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.14 NAME ''supportedSASLMechanisms'' DESC ''RFC4512: supported SASL mechanisms'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.4203.1.3.5 NAME ''supportedFeatures'' DESC ''RFC4512: features supported by the server'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 USAGE dSAOperation )'
	     '( 1.3.6.1.1.4 NAME ''vendorName'' DESC ''RFC3045: name of implementation vendor'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE NO-USER-MODIFICATION USAGE dSAOperation )'
	     '( 1.3.6.1.1.5 NAME ''vendorVersion'' DESC ''RFC3045: version of implementation'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE NO-USER-MODIFICATION USAGE dSAOperation )'
	     '( 2.5.21.4 NAME ''matchingRules'' DESC ''RFC4512: matching rules'' EQUALITY objectIdentifierFirstComponentMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.30 USAGE directoryOperation )'
	     '( 2.5.21.5 NAME ''attributeTypes'' DESC ''RFC4512: attribute types'' EQUALITY objectIdentifierFirstComponentMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.3 USAGE directoryOperation )'
	     '( 2.5.21.6 NAME ''objectClasses'' DESC ''RFC4512: object classes'' EQUALITY objectIdentifierFirstComponentMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.37 USAGE directoryOperation )'
	     '( 2.5.21.8 NAME ''matchingRuleUse'' DESC ''RFC4512: matching rule uses'' EQUALITY objectIdentifierFirstComponentMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.31 USAGE directoryOperation )'
	     '( 1.3.6.1.4.1.1466.101.120.16 NAME ''ldapSyntaxes'' DESC ''RFC4512: LDAP syntaxes'' EQUALITY objectIdentifierFirstComponentMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.54 USAGE directoryOperation )'
	     '( 2.5.4.1 NAME ( ''aliasedObjectName'' ''aliasedEntryName'' ) DESC ''RFC4512: name of aliased object'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE )'
	     '( 2.16.840.1.113730.3.1.34 NAME ''ref'' DESC ''RFC3296: subordinate referral URL'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 USAGE distributedOperation )'
	     '( 1.3.6.1.4.1.1466.101.119.3 NAME ''entryTtl'' DESC ''RFC2589: entry time-to-live'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE NO-USER-MODIFICATION USAGE dSAOperation )'
	     '( 1.3.6.1.4.1.1466.101.119.4 NAME ''dynamicSubtrees'' DESC ''RFC2589: dynamic subtrees'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 NO-USER-MODIFICATION USAGE dSAOperation )'
	     '( 2.5.4.49 NAME ''distinguishedName'' DESC ''RFC4519: common supertype of DN attributes'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 2.5.4.41 NAME ''name'' DESC ''RFC4519: common supertype of name attributes'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{32768} )'
	     '( 2.5.4.3 NAME ( ''cn'' ''commonName'' ) DESC ''RFC4519: common name(s) for which the entity is known by'' SUP name )'
	     '( 0.9.2342.19200300.100.1.1 NAME ( ''uid'' ''userid'' ) DESC ''RFC4519: user identifier'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 1.3.6.1.1.1.1.0 NAME ''uidNumber'' DESC ''RFC2307: An integer uniquely identifying a user in an administrative domain'' EQUALITY integerMatch ORDERING integerOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.1 NAME ''gidNumber'' DESC ''RFC2307: An integer uniquely identifying a group in an administrative domain'' EQUALITY integerMatch ORDERING integerOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 2.5.4.35 NAME ''userPassword'' DESC ''RFC4519/2307: password of user'' EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.40{128} )'
	     '( 1.3.6.1.4.1.250.1.57 NAME ''labeledURI'' DESC ''RFC2079: Uniform Resource Identifier with optional label'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 2.5.4.13 NAME ''description'' DESC ''RFC4519: descriptive information'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{1024} )'
	     '( 2.5.4.34 NAME ''seeAlso'' DESC ''RFC4519: DN of related object'' SUP distinguishedName )'
	     '( 1.3.6.1.4.1.4203.666.1.60 NAME ''pKCS8PrivateKey'' DESC ''PKCS#8 PrivateKeyInfo, use ;binary'' EQUALITY privateKeyMatch SYNTAX 1.2.840.113549.1.8.1.1 )'
	     '( 1.3.6.1.4.1.42.2.27.8.1.29 NAME ''pwdLastSuccess'' DESC ''The timestamp of the last successful authentication'' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.4.2 NAME ''knowledgeInformation'' DESC ''RFC2256: knowledge information'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{32768} )'
	     '( 2.5.4.4 NAME ( ''sn'' ''surname'' ) DESC ''RFC2256: last (family) name(s) for which the entity is known by'' SUP name )'
	     '( 2.5.4.5 NAME ''serialNumber'' DESC ''RFC2256: serial number of the entity'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.44{64} )'
	     '( 2.5.4.6 NAME ( ''c'' ''countryName'' ) DESC ''RFC4519: two-letter ISO-3166 country code'' SUP name SYNTAX 1.3.6.1.4.1.1466.115.121.1.11 SINGLE-VALUE )'
	     '( 2.5.4.7 NAME ( ''l'' ''localityName'' ) DESC ''RFC2256: locality which this object resides in'' SUP name )'
	     '( 2.5.4.8 NAME ( ''st'' ''stateOrProvinceName'' ) DESC ''RFC2256: state or province which this object resides in'' SUP name )'
	     '( 2.5.4.9 NAME ( ''street'' ''streetAddress'' ) DESC ''RFC2256: street address of this object'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{128} )'
	     '( 2.5.4.10 NAME ( ''o'' ''organizationName'' ) DESC ''RFC2256: organization this object belongs to'' SUP name )'
	     '( 2.5.4.11 NAME ( ''ou'' ''organizationalUnitName'' ) DESC ''RFC2256: organizational unit this object belongs to'' SUP name )'
	     '( 2.5.4.12 NAME ''title'' DESC ''RFC2256: title associated with the entity'' SUP name )'
	     '( 2.5.4.14 NAME ''searchGuide'' DESC ''RFC2256: search guide, deprecated by enhancedSearchGuide'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.25 )'
	     '( 2.5.4.15 NAME ''businessCategory'' DESC ''RFC2256: business category'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{128} )'
	     '( 2.5.4.16 NAME ''postalAddress'' DESC ''RFC2256: postal address'' EQUALITY caseIgnoreListMatch SUBSTR caseIgnoreListSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.41 )'
	     '( 2.5.4.17 NAME ''postalCode'' DESC ''RFC2256: postal code'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{40} )'
	     '( 2.5.4.18 NAME ''postOfficeBox'' DESC ''RFC2256: Post Office Box'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{40} )'
	     '( 2.5.4.19 NAME ''physicalDeliveryOfficeName'' DESC ''RFC2256: Physical Delivery Office Name'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{128} )'
	     '( 2.5.4.20 NAME ''telephoneNumber'' DESC ''RFC2256: Telephone Number'' EQUALITY telephoneNumberMatch SUBSTR telephoneNumberSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.50{32} )'
	     '( 2.5.4.21 NAME ''telexNumber'' DESC ''RFC2256: Telex Number'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.52 )'
	     '( 2.5.4.22 NAME ''teletexTerminalIdentifier'' DESC ''RFC2256: Teletex Terminal Identifier'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.51 )'
	     '( 2.5.4.23 NAME ( ''facsimileTelephoneNumber'' ''fax'' ) DESC ''RFC2256: Facsimile (Fax) Telephone Number'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.22 )'
	     '( 2.5.4.24 NAME ''x121Address'' DESC ''RFC2256: X.121 Address'' EQUALITY numericStringMatch SUBSTR numericStringSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.36{15} )'
	     '( 2.5.4.25 NAME ''internationaliSDNNumber'' DESC ''RFC2256: international ISDN number'' EQUALITY numericStringMatch SUBSTR numericStringSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.36{16} )'
	     '( 2.5.4.26 NAME ''registeredAddress'' DESC ''RFC2256: registered postal address'' SUP postalAddress SYNTAX 1.3.6.1.4.1.1466.115.121.1.41 )'
	     '( 2.5.4.27 NAME ''destinationIndicator'' DESC ''RFC2256: destination indicator'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.44{128} )'
	     '( 2.5.4.28 NAME ''preferredDeliveryMethod'' DESC ''RFC2256: preferred delivery method'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.14 SINGLE-VALUE )'
	     '( 2.5.4.29 NAME ''presentationAddress'' DESC ''RFC2256: presentation address'' EQUALITY presentationAddressMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.43 SINGLE-VALUE )'
	     '( 2.5.4.30 NAME ''supportedApplicationContext'' DESC ''RFC2256: supported application context'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 )'
	     '( 2.5.4.31 NAME ''member'' DESC ''RFC2256: member of a group'' SUP distinguishedName )'
	     '( 2.5.4.32 NAME ''owner'' DESC ''RFC2256: owner (of the object)'' SUP distinguishedName )'
	     '( 2.5.4.33 NAME ''roleOccupant'' DESC ''RFC2256: occupant of role'' SUP distinguishedName )'
	     '( 2.5.4.36 NAME ''userCertificate'' DESC ''RFC2256: X.509 user certificate, use ;binary'' EQUALITY certificateExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.8 )'
	     '( 2.5.4.37 NAME ''cACertificate'' DESC ''RFC2256: X.509 CA certificate, use ;binary'' EQUALITY certificateExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.8 )'
	     '( 2.5.4.38 NAME ''authorityRevocationList'' DESC ''RFC2256: X.509 authority revocation list, use ;binary'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.9 )'
	     '( 2.5.4.39 NAME ''certificateRevocationList'' DESC ''RFC2256: X.509 certificate revocation list, use ;binary'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.9 )'
	     '( 2.5.4.40 NAME ''crossCertificatePair'' DESC ''RFC2256: X.509 cross certificate pair, use ;binary'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.10 )'
	     '( 2.5.4.42 NAME ( ''givenName'' ''gn'' ) DESC ''RFC2256: first name(s) for which the entity is known by'' SUP name )'
	     '( 2.5.4.43 NAME ''initials'' DESC ''RFC2256: initials of some or all of names, but not the surname(s).'' SUP name )'
	     '( 2.5.4.44 NAME ''generationQualifier'' DESC ''RFC2256: name qualifier indicating a generation'' SUP name )'
	     '( 2.5.4.45 NAME ''x500UniqueIdentifier'' DESC ''RFC2256: X.500 unique identifier'' EQUALITY bitStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.6 )'
	     '( 2.5.4.46 NAME ''dnQualifier'' DESC ''RFC2256: DN qualifier'' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.44 )'
	     '( 2.5.4.47 NAME ''enhancedSearchGuide'' DESC ''RFC2256: enhanced search guide'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.21 )'
	     '( 2.5.4.48 NAME ''protocolInformation'' DESC ''RFC2256: protocol information'' EQUALITY protocolInformationMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.42 )'
	     '( 2.5.4.50 NAME ''uniqueMember'' DESC ''RFC2256: unique member of a group'' EQUALITY uniqueMemberMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.34 )'
	     '( 2.5.4.51 NAME ''houseIdentifier'' DESC ''RFC2256: house identifier'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{32768} )'
	     '( 2.5.4.52 NAME ''supportedAlgorithms'' DESC ''RFC2256: supported algorithms'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.49 )'
	     '( 2.5.4.53 NAME ''deltaRevocationList'' DESC ''RFC2256: delta revocation list; use ;binary'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.9 )'
	     '( 2.5.4.54 NAME ''dmdName'' DESC ''RFC2256: name of DMD'' SUP name )'
	     '( 2.5.4.65 NAME ''pseudonym'' DESC ''X.520(4th): pseudonym for the object'' SUP name )'
	     '( 0.9.2342.19200300.100.1.3 NAME ( ''mail'' ''rfc822Mailbox'' ) DESC ''RFC1274: RFC822 Mailbox'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{256} )'
	     '( 0.9.2342.19200300.100.1.25 NAME ( ''dc'' ''domainComponent'' ) DESC ''RFC1274/2247: domain component'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )'
	     '( 0.9.2342.19200300.100.1.37 NAME ''associatedDomain'' DESC ''RFC1274: domain associated with object'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 1.2.840.113549.1.9.1 NAME ( ''email'' ''emailAddress'' ''pkcs9email'' ) DESC ''RFC3280: legacy attribute for email addresses in DNs'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128} )'
	     '( 0.9.2342.19200300.100.1.2 NAME ''textEncodedORAddress'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.4 NAME ''info'' DESC ''RFC1274: general information'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{2048} )'
	     '( 0.9.2342.19200300.100.1.5 NAME ( ''drink'' ''favouriteDrink'' ) DESC ''RFC1274: favorite drink'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.6 NAME ''roomNumber'' DESC ''RFC1274: room number'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.7 NAME ''photo'' DESC ''RFC1274: photo (G3 fax)'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.23{25000} )'
	     '( 0.9.2342.19200300.100.1.8 NAME ''userClass'' DESC ''RFC1274: category of user'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.9 NAME ''host'' DESC ''RFC1274: host computer'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.10 NAME ''manager'' DESC ''RFC1274: DN of manager'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 0.9.2342.19200300.100.1.11 NAME ''documentIdentifier'' DESC ''RFC1274: unique identifier of document'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.12 NAME ''documentTitle'' DESC ''RFC1274: title of document'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.13 NAME ''documentVersion'' DESC ''RFC1274: version of document'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.14 NAME ''documentAuthor'' DESC ''RFC1274: DN of author of document'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 0.9.2342.19200300.100.1.15 NAME ''documentLocation'' DESC ''RFC1274: location of document original'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.20 NAME ( ''homePhone'' ''homeTelephoneNumber'' ) DESC ''RFC1274: home telephone number'' EQUALITY telephoneNumberMatch SUBSTR telephoneNumberSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.50 )'
	     '( 0.9.2342.19200300.100.1.21 NAME ''secretary'' DESC ''RFC1274: DN of secretary'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 0.9.2342.19200300.100.1.22 NAME ''otherMailbox'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.39 )'
	     '( 0.9.2342.19200300.100.1.26 NAME ''aRecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.27 NAME ''mDRecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.28 NAME ''mXRecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.29 NAME ''nSRecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.30 NAME ''sOARecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.31 NAME ''cNAMERecord'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 0.9.2342.19200300.100.1.38 NAME ''associatedName'' DESC ''RFC1274: DN of entry associated with domain'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 0.9.2342.19200300.100.1.39 NAME ''homePostalAddress'' DESC ''RFC1274: home postal address'' EQUALITY caseIgnoreListMatch SUBSTR caseIgnoreListSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.41 )'
	     '( 0.9.2342.19200300.100.1.40 NAME ''personalTitle'' DESC ''RFC1274: personal title'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.41 NAME ( ''mobile'' ''mobileTelephoneNumber'' ) DESC ''RFC1274: mobile telephone number'' EQUALITY telephoneNumberMatch SUBSTR telephoneNumberSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.50 )'
	     '( 0.9.2342.19200300.100.1.42 NAME ( ''pager'' ''pagerTelephoneNumber'' ) DESC ''RFC1274: pager telephone number'' EQUALITY telephoneNumberMatch SUBSTR telephoneNumberSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.50 )'
	     '( 0.9.2342.19200300.100.1.43 NAME ( ''co'' ''friendlyCountryName'' ) DESC ''RFC1274: friendly country name'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 0.9.2342.19200300.100.1.44 NAME ''uniqueIdentifier'' DESC ''RFC1274: unique identifer'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.45 NAME ''organizationalStatus'' DESC ''RFC1274: organizational status'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.46 NAME ''janetMailbox'' DESC ''RFC1274: Janet mailbox'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{256} )'
	     '( 0.9.2342.19200300.100.1.47 NAME ''mailPreferenceOption'' DESC ''RFC1274: mail preference option'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )'
	     '( 0.9.2342.19200300.100.1.48 NAME ''buildingName'' DESC ''RFC1274: name of building'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{256} )'
	     '( 0.9.2342.19200300.100.1.49 NAME ''dSAQuality'' DESC ''RFC1274: DSA Quality'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.19 SINGLE-VALUE )'
	     '( 0.9.2342.19200300.100.1.50 NAME ''singleLevelQuality'' DESC ''RFC1274: Single Level Quality'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.13 SINGLE-VALUE )'
	     '( 0.9.2342.19200300.100.1.51 NAME ''subtreeMinimumQuality'' DESC ''RFC1274: Subtree Minimum Quality'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.13 SINGLE-VALUE )'
	     '( 0.9.2342.19200300.100.1.52 NAME ''subtreeMaximumQuality'' DESC ''RFC1274: Subtree Maximum Quality'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.13 SINGLE-VALUE )'
	     '( 0.9.2342.19200300.100.1.53 NAME ''personalSignature'' DESC ''RFC1274: Personal Signature (G3 fax)'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.23 )'
	     '( 0.9.2342.19200300.100.1.54 NAME ''dITRedirect'' DESC ''RFC1274: DIT Redirect'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 0.9.2342.19200300.100.1.55 NAME ''audio'' DESC ''RFC1274: audio (u-law)'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.4{25000} )'
	     '( 0.9.2342.19200300.100.1.56 NAME ''documentPublisher'' DESC ''RFC1274: publisher of document'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.1.1.1.2 NAME ''gecos'' DESC ''The GECOS field; the common name'' EQUALITY caseIgnoreIA5Match SUBSTR caseIgnoreIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.3 NAME ''homeDirectory'' DESC ''The absolute path to the home directory'' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.4 NAME ''loginShell'' DESC ''The path to the login shell'' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.5 NAME ''shadowLastChange'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.6 NAME ''shadowMin'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.7 NAME ''shadowMax'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.8 NAME ''shadowWarning'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.9 NAME ''shadowInactive'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.10 NAME ''shadowExpire'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.11 NAME ''shadowFlag'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.12 NAME ''memberUid'' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 1.3.6.1.1.1.1.13 NAME ''memberNisNetgroup'' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 1.3.6.1.1.1.1.14 NAME ''nisNetgroupTriple'' DESC ''Netgroup triple'' SYNTAX 1.3.6.1.1.1.0.0 )'
	     '( 1.3.6.1.1.1.1.15 NAME ''ipServicePort'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.16 NAME ''ipServiceProtocol'' SUP name )'
	     '( 1.3.6.1.1.1.1.17 NAME ''ipProtocolNumber'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.18 NAME ''oncRpcNumber'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.19 NAME ''ipHostNumber'' DESC ''IP address'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128} )'
	     '( 1.3.6.1.1.1.1.20 NAME ''ipNetworkNumber'' DESC ''IP network'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128} SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.21 NAME ''ipNetmaskNumber'' DESC ''IP netmask'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128} SINGLE-VALUE )'
	     '( 1.3.6.1.1.1.1.22 NAME ''macAddress'' DESC ''MAC address'' EQUALITY caseIgnoreIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128} )'
	     '( 1.3.6.1.1.1.1.23 NAME ''bootParameter'' DESC ''rpc.bootparamd parameter'' SYNTAX 1.3.6.1.1.1.0.1 )'
	     '( 1.3.6.1.1.1.1.24 NAME ''bootFile'' DESC ''Boot image name'' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )'
	     '( 1.3.6.1.1.1.1.26 NAME ''nisMapName'' SUP name )'
	     '( 1.3.6.1.1.1.1.27 NAME ''nisMapEntry'' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{1024} SINGLE-VALUE )'
	     '( 2.16.840.1.113730.3.1.1 NAME ''carLicense'' DESC ''RFC2798: vehicle license or registration plate'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 2.16.840.1.113730.3.1.2 NAME ''departmentNumber'' DESC ''RFC2798: identifies a department within an organization'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 2.16.840.1.113730.3.1.241 NAME ''displayName'' DESC ''RFC2798: preferred name to be used when displaying entries'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 2.16.840.1.113730.3.1.3 NAME ''employeeNumber'' DESC ''RFC2798: numerically identifies an employee within an organization'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 2.16.840.1.113730.3.1.4 NAME ''employeeType'' DESC ''RFC2798: type of employment for a person'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 0.9.2342.19200300.100.1.60 NAME ''jpegPhoto'' DESC ''RFC2798: a JPEG image'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.28 )'
	     '( 2.16.840.1.113730.3.1.39 NAME ''preferredLanguage'' DESC ''RFC2798: preferred written or spoken language for a person'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 2.16.840.1.113730.3.1.40 NAME ''userSMIMECertificate'' DESC ''RFC2798: PKCS#7 SignedData used to support S/MIME'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.5 )'
	     '( 2.16.840.1.113730.3.1.216 NAME ''userPKCS12'' DESC ''RFC2798: personal identity information, a PKCS #12 PFX'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.5 )' )
]

{ #category : 'accessing' }
LDAPAttributeType >> canBeModified [

	^ self cannotBeModified not
]

{ #category : 'accessing' }
LDAPAttributeType >> cannotBeModified [

	^ noUserModification ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> collective: anObject [

	collective := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> equality [

	^ equality
]

{ #category : 'accessing' }
LDAPAttributeType >> equality: anObject [

	equality := anObject
]

{ #category : 'accessing - extension' }
LDAPAttributeType >> extensions: aDictionary [

	| supported |
	self checkSupport: #( 'X-ORDERED' ) in: aDictionary.
	
	supported := #( 'VALUES' 'SIBLINGS' ).
	aDictionary at: 'X-ORDERED' ifPresent: [ :values | values do: [ :value | 
		(supported includes: value) 
			ifTrue: [ 
				value = 'VALUES' ifTrue: [ hasOrderedValues := true ] ifFalse: [ hasOrderedSiblings := true ]
			] 
			ifFalse: [ self error: ('Unknown extension value for X-ORDERED: ', value) ] 
	] ].
]

{ #category : 'accessing' }
LDAPAttributeType >> hasOrderedSiblings [

	^ hasOrderedSiblings ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> hasOrderedValues [

	^ hasOrderedValues ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> isCollective [

	^ collective ifNil: [ false ]
]

{ #category : 'accessing' }
LDAPAttributeType >> isMultipleValue [

	^ self isSingleValue not
]

{ #category : 'testing' }
LDAPAttributeType >> isOperationalAttribute [

	^ self isUserAttribute not

]

{ #category : 'accessing' }
LDAPAttributeType >> isSingleValue [

	^ singleValue ifNil: [ false ]
]

{ #category : 'testing' }
LDAPAttributeType >> isUserAttribute [

	^ usage = #userApplications

]

{ #category : 'accessing' }
LDAPAttributeType >> noUserModification: anObject [

	noUserModification := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> ordering [

	^ ordering
]

{ #category : 'accessing' }
LDAPAttributeType >> ordering: anObject [

	ordering := anObject
]

{ #category : 'building' }
LDAPAttributeType >> pullEquality [

	equality ifNotNil: [ ^ equality ].
	superior ifNil: [ ^ nil ].
	^ equality := superior pullEquality
]

{ #category : 'building' }
LDAPAttributeType >> pullOrdering [

	ordering ifNotNil: [ ^ ordering ].
	superior ifNil: [ ^ nil ].
	^ ordering := superior pullOrdering
]

{ #category : 'building' }
LDAPAttributeType >> pullProperties [

	self pullSyntax; pullEquality; pullOrdering; pullSubstring.
]

{ #category : 'building' }
LDAPAttributeType >> pullSubstring [

	substr ifNotNil: [ ^ substr ].
	superior ifNil: [ ^ nil ].
	^ substr := superior pullSubstring
]

{ #category : 'building' }
LDAPAttributeType >> pullSyntax [
	
	syntax ifNotNil: [ ^ { syntax. syntaxLength } ].
	^ superior pullSyntax bind: [ :s :sl | syntax := s. syntaxLength := sl. { s. sl } ]
]

{ #category : 'accessing' }
LDAPAttributeType >> singleValue: anObject [

	singleValue := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> substring [

	^ substr
]

{ #category : 'accessing' }
LDAPAttributeType >> substring: anObject [

	substr := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> superior [

	^ superior
]

{ #category : 'accessing' }
LDAPAttributeType >> superior: anObject [

	superior := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> syntax [

	^ syntax
]

{ #category : 'accessing' }
LDAPAttributeType >> syntax: anObject [

	syntax := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> syntaxLength [

	^ syntaxLength
]

{ #category : 'accessing' }
LDAPAttributeType >> syntaxLength: anObject [

	syntaxLength := anObject
]

{ #category : 'accessing' }
LDAPAttributeType >> usage [

	^ usage
]

{ #category : 'accessing' }
LDAPAttributeType >> usage: anObject [

	usage := anObject
]
