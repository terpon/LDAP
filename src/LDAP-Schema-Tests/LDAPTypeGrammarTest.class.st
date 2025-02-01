Class {
	#name : 'LDAPTypeGrammarTest',
	#superclass : 'LDAPSchemaGrammarTest',
	#category : 'LDAP-Schema-Tests',
	#package : 'LDAP-Schema-Tests'
}

{ #category : 'accessing' }
LDAPTypeGrammarTest >> data [

	^ #( '( 2.5.4.0 NAME ''objectClass'' DESC ''RFC4512: object classes of the entity'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 )'
	     '( 2.5.21.9 NAME ''structuralObjectClass'' DESC ''RFC4512: structural object class of entry'' EQUALITY objectIdentifierMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.38 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.1 NAME ''createTimestamp'' DESC ''RFC4512: time which object was created'' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.2 NAME ''modifyTimestamp'' DESC ''RFC4512: time which object was last modified'' EQUALITY generalizedTimeMatch ORDERING generalizedTimeOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.3 NAME ''creatorsName'' DESC ''RFC4512: name of creator'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.4 NAME ''modifiersName'' DESC ''RFC4512: name of last modifier'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.9 NAME ''hasSubordinates'' DESC ''X.501: entry has children'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
	     '( 2.5.18.10 NAME ''subschemaSubentry'' DESC ''RFC4512: name of controlling subschema entry'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )'
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
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.78 NAME ''olcConfigFile'' DESC ''File for slapd configuration directives'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.79 NAME ''olcConfigDir'' DESC ''Directory for slapd configuration backend'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.1 NAME ''olcAccess'' DESC ''Access Control List'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.86 NAME ''olcAddContentAcl'' DESC ''Check ACLs against content of Add ops'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.2 NAME ''olcAllows'' DESC ''Allowed set of deprecated features'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.3 NAME ''olcArgsFile'' DESC ''File for slapd command line options'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.5 NAME ''olcAttributeOptions'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.4 NAME ''olcAttributeTypes'' DESC ''OpenLDAP attributeTypes'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.6 NAME ''olcAuthIDRewrite'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.7 NAME ''olcAuthzPolicy'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.8 NAME ''olcAuthzRegexp'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.9 NAME ''olcBackend'' DESC ''A type of backend'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE X-ORDERED ''SIBLINGS'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.10 NAME ''olcConcurrency'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.11 NAME ''olcConnMaxPending'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.12 NAME ''olcConnMaxPendingAuth'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.13 NAME ''olcDatabase'' DESC ''The backend type for a database instance'' SUP olcBackend SINGLE-VALUE X-ORDERED ''SIBLINGS'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.14 NAME ''olcDefaultSearchBase'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.21 NAME ''olcDisabled'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.15 NAME ''olcDisallows'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.16 NAME ''olcDitContentRules'' DESC ''OpenLDAP DIT content rules'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.20 NAME ''olcExtraAttrs'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.17 NAME ''olcGentleHUP'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.17 NAME ''olcHidden'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.18 NAME ''olcIdleTimeout'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.19 NAME ''olcInclude'' SUP labeledURI )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.94 NAME ''olcIndexHash64'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.20 NAME ''olcIndexSubstrIfMinLen'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.21 NAME ''olcIndexSubstrIfMaxLen'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.22 NAME ''olcIndexSubstrAnyLen'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.23 NAME ''olcIndexSubstrAnyStep'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.84 NAME ''olcIndexIntLen'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.4 NAME ''olcLastMod'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.22 NAME ''olcLastBind'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.23 NAME ''olcLastBindPrecision'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.85 NAME ''olcLdapSyntaxes'' DESC ''OpenLDAP ldapSyntax'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.5 NAME ''olcLimits'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.93 NAME ''olcListenerThreads'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.26 NAME ''olcLocalSSF'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.27 NAME ''olcLogFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.104 NAME ''olcLogFileFormat'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.102 NAME ''olcLogFileOnly'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.103 NAME ''olcLogFileRotate'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.28 NAME ''olcLogLevel'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.6 NAME ''olcMaxDerefDepth'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.101 NAME ''olcMaxFilterDepth'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.16 NAME ( ''olcMultiProvider'' ''olcMirrorMode'' ) EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.30 NAME ''olcModuleLoad'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.31 NAME ''olcModulePath'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.18 NAME ''olcMonitoring'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.32 NAME ''olcObjectClasses'' DESC ''OpenLDAP object classes'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.33 NAME ''olcObjectIdentifier'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.34 NAME ''olcOverlay'' SUP olcDatabase SINGLE-VALUE X-ORDERED ''SIBLINGS'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.35 NAME ''olcPasswordCryptSaltFormat'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.36 NAME ''olcPasswordHash'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.37 NAME ''olcPidFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.38 NAME ''olcPlugin'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.39 NAME ''olcPluginLogFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.40 NAME ''olcReadOnly'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.41 NAME ''olcReferral'' SUP labeledURI SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.7 NAME ''olcReplica'' SUP labeledURI EQUALITY caseIgnoreMatch X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.43 NAME ''olcReplicaArgsFile'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.44 NAME ''olcReplicaPidFile'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.45 NAME ''olcReplicationInterval'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.46 NAME ''olcReplogFile'' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.47 NAME ''olcRequires'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.48 NAME ''olcRestrict'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.49 NAME ''olcReverseLookup'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.8 NAME ''olcRootDN'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.51 NAME ''olcRootDSE'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.9 NAME ''olcRootPW'' EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.40 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.89 NAME ''olcSaslAuxprops'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.91 NAME ''olcSaslAuxpropsDontUseCopy'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.92 NAME ''olcSaslAuxpropsDontUseCopyIgnore'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.100 NAME ''olcSaslCBinding'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.53 NAME ''olcSaslHost'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.54 NAME ''olcSaslRealm'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.56 NAME ''olcSaslSecProps'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.58 NAME ''olcSchemaDN'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.59 NAME ''olcSecurity'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.81 NAME ''olcServerID'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.60 NAME ''olcSizeLimit'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.61 NAME ''olcSockbufMaxIncoming'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.62 NAME ''olcSockbufMaxIncomingAuth'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.83 NAME ''olcSortVals'' DESC ''Attributes whose values will always be sorted'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.15 NAME ''olcSubordinate'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.10 NAME ''olcSuffix'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.19 NAME ''olcSyncUseSubentry'' DESC ''Store sync context in a subentry'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.11 NAME ''olcSyncrepl'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 X-ORDERED ''VALUES'' )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.90 NAME ''olcTCPBuffer'' DESC ''Custom TCP buffer size'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.66 NAME ''olcThreads'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.95 NAME ''olcThreadQueues'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.67 NAME ''olcTimeLimit'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.97 NAME ''olcTLSCACertificate'' DESC ''X.509 certificate, must use ;binary'' EQUALITY certificateExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.8 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.68 NAME ''olcTLSCACertificateFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.69 NAME ''olcTLSCACertificatePath'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.98 NAME ''olcTLSCertificate'' DESC ''X.509 certificate, must use ;binary'' EQUALITY certificateExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.8 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.70 NAME ''olcTLSCertificateFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.99 NAME ''olcTLSCertificateKey'' DESC ''X.509 privateKey, must use ;binary'' EQUALITY privateKeyMatch SYNTAX 1.2.840.113549.1.8.1.1 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.71 NAME ''olcTLSCertificateKeyFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.72 NAME ''olcTLSCipherSuite'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.73 NAME ''olcTLSCRLCheck'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.82 NAME ''olcTLSCRLFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.74 NAME ''olcTLSRandFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.75 NAME ''olcTLSVerifyClient'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.77 NAME ''olcTLSDHParamFile'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.96 NAME ''olcTLSECName'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.87 NAME ''olcTLSProtocolMin'' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.80 NAME ''olcToolThreads'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.12 NAME ''olcUpdateDN'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.13 NAME ''olcUpdateRef'' SUP labeledURI EQUALITY caseIgnoreMatch )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.0.88 NAME ''olcWriteTimeout'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.1 NAME ''olcDbDirectory'' DESC ''Directory for database content'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.1.12.1 NAME ''olcBkMdbIdlExp'' DESC ''Power of 2 used to set IDL size'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.1.2 NAME ''olcDbCheckpoint'' DESC ''Database checkpoint interval in kbytes and minutes'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.1.4 NAME ''olcDbNoSync'' DESC ''Disable synchronous database writes'' EQUALITY booleanMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.3 NAME ''olcDbEnvFlags'' DESC ''Database environment flags'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.2 NAME ''olcDbIndex'' DESC ''Attribute index parameters'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.4 NAME ''olcDbMaxEntrySize'' DESC ''Maximum size of an entry in bytes'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.1 NAME ''olcDbMaxReaders'' DESC ''Maximum number of threads that may access the DB concurrently'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.2 NAME ''olcDbMaxSize'' DESC ''Maximum size of DB in bytes'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.0.3 NAME ''olcDbMode'' DESC ''Unix permissions of database files'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.6 NAME ''olcDbMultival'' DESC ''Hi/Lo thresholds for splitting multivalued attr out of main blob'' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.12.5 NAME ''olcDbRtxnSize'' DESC ''Number of entries to process in one read transaction'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
	     '( 1.3.6.1.4.1.4203.1.12.2.3.2.1.9 NAME ''olcDbSearchStack'' DESC ''Depth of search stack in IDLs'' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )'
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
LDAPTypeGrammarTest >> parserClass [
	^ LDAPTypeGrammar 
]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testCollective [ 

	self parse: ' COLLECTIVE' rule: #collective.
	self assert: result.
	
	self fail: ' collective' rule: #collective.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testData [

	self data do: [ :string |
		self parse: string.
	]
]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testEquality [

	self parse: ' EQUALITY objectIdentifierMatch' rule: #equality.
	self assert: result equals: 'objectIdentifierMatch'.
	
	self fail: ' EQUALITY object_IdentifierMatch' rule: #equality.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testNoUserModification [ 

	self parse: ' NO-USER-MODIFICATION' rule: #noUserModification.
	self assert: result.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testNoidlen [

	self parse: '0' rule: #noidlen.
	
	self parse: '1.2.3' rule: #noidlen.
	self assert: result equals: #('1.2.3' nil).
	
	self parse: '1.2.3{64}' rule: #noidlen.
	self assert: result equals: #('1.2.3' 64).
]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testOrdering [

	self parse: ' ORDERING UUIDOrderingMatch' rule: #ordering.
	self assert: result equals: 'UUIDOrderingMatch'.
	
	self fail: ' ORDERING 1UUIDOrderingMatch' rule: #ordering.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testSingleValue [ 

	self parse: ' SINGLE-VALUE' rule: #singleValue.
	self assert: result.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testSubstr [

	self parse: ' SUBSTR caseIgnoreIA5SubstringsMatch' rule: #substr.
	self assert: result equals: 'caseIgnoreIA5SubstringsMatch'.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testSuperior [ 

	self parse: ' SUP top' rule: #superior.
	self assert: result equals: 'top'.
	self parse: ' SUP 0.5.6' rule: #superior.
	self assert: result equals: '0.5.6'.

	self fail: ' SUP (a $ b)' rule: #superior.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testSyntax [

	self parse: ' SYNTAX 1.3.6.1.1.16.1' rule: #syntax.
	self assert: result equals: #('1.3.6.1.1.16.1' nil).
	
	self parse: ' SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{128}' rule: #syntax.
	self assert: result equals: #('1.3.6.1.4.1.1466.115.121.1.26' 128).
]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testType [

	self fail: '(-)' rule: #type.
	self parse: '( 2.5.4.42 NAME ( ''givenName'' ''gn'' ) DESC ''RFC2256: first name(s) for which the entity is known by'' SUP name )' rule: #type.
	self assert: result equals: {
			'2.5.4.42'. #( 'givenName' 'gn' ).
			'RFC2256: first name(s) for which the entity is known by'.
			false. 'name'.
			nil. nil. nil. nil. false. false. false. nil.
			Dictionary empty }.

	self parse: '( 2.5.4.41 NAME ''name'' DESC ''RFC4519: common supertype of name attributes'' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{32768} )' rule: #type.
	self assert: result equals: {
			'2.5.4.41'. #( 'name' ). 'RFC4519: common supertype of name attributes'.
			false. nil.
			'caseIgnoreMatch'. nil. 'caseIgnoreSubstringsMatch'. 
			#('1.3.6.1.4.1.1466.115.121.1.15' 32768). false. false. false. nil.
			Dictionary empty }.
				   
	self parse: '( 2.5.18.10 NAME ''subschemaSubentry'' DESC ''RFC4512: name of controlling subschema entry'' EQUALITY distinguishedNameMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.12 SINGLE-VALUE NO-USER-MODIFICATION USAGE directoryOperation )' rule: #type.
	self assert: result equals: {
			'2.5.18.10'. #( 'subschemaSubentry' ). 'RFC4512: name of controlling subschema entry'.
			false. nil.
			'distinguishedNameMatch'. nil. nil. 
			#('1.3.6.1.4.1.1466.115.121.1.12' nil). 
			true. false. true. #directoryOperation.
			Dictionary empty }.

]

{ #category : 'tests' }
LDAPTypeGrammarTest >> testUsage [

	self parse: ' USAGE userApplications' rule: #usage.
	self assert: result equals: #userApplications.
	self parse: ' USAGE directoryOperation' rule: #usage.
	self assert: result equals: #directoryOperation.
	self parse: ' USAGE distributedOperation' rule: #usage.
	self assert: result equals: #distributedOperation.
	self parse: ' USAGE dSAOperation' rule: #usage.
	self assert: result equals: #dSAOperation.

	self fail: ' USAGE userNotFound' rule: #usage.
]
