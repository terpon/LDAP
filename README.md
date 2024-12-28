
# LDAP Support for Pharo

LDAP (Lightweight Directory Access Protocol) is a network protocol for remote directories. LDAP is mainly used for authentication of users into the mails servers, enterprise applications or biometric systems.

This implementation allows Pharo to communicate with such LDAP directories. It is fully written in [Pharo smalltalk](https://pharo.org/) and does not require access to native libraries.


## Installing
Minimal package loading:
```Smalltalk
Metacello new
 	baseline: 'LDAP';
 	repository: 'github://terpon/LDAP:pharo13/src';
	load: 'Core'.
```
Replace `pharo13` with your Pharo image version. Check that the branch exists first. Not all versions might be supported.

All packages including user interfaces and tests:
```Smalltalk
Metacello new
 	baseline: 'LDAP';
 	repository: 'github://terpon/LDAP:pharo13/src';
	load: 'All'.
```


### Loading for Pharo 9
Previous version can be loaded from the `main` branch. It was tested on Pharo 9 but might work on latest image versions.

```Smalltalk
Metacello new
 	baseline: 'LDAP';
 	repository: 'github://terpon/LDAP:main/src';
	load.
```

Note: code examples won’t work as many names have change. Refer to that branch documentation for correct syntax.

### Loading for Pharo 7 and older
Load the project using the configuration and the *commitish* corresponding to the legacy tag, branch or even SHA as the following:
```Smalltalk
Metacello new
 	configuration: 'LDAP';
	githubUser: 'pharo-contributions' project: 'LDAP' 
		commitish: 'd8f505b34dd2489eb29f61cf85512eb943b35e5a' 
		path: 'src';
	version: #stable;
	load.
```

At this point, no branch or tag exist, so use the most current SHA at that point: [LDAP legacy](https://github.com/pharo-contributions/LDAP/tree/d8f505b34dd2489eb29f61cf85512eb943b35e5a).
See [How to load a git project](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md#how-to-load-a-git-project-using-its-baseline) for more information.

## Code Example

Here is a sample snippet of code to communicate with a LDAP server:

```Smalltalk
| connection bind command add attrs search |
connection := (LDAPConnection to: 'localhost' port: 389).
bind := LDAPBindRequest new username: 'cn=admin,dc=example,dc=com'; password: 'secret'.
command := connection request: bind.
command wait.

attrs := Dictionary new
    at: 'objectClass' put: { 'inetOrgPerson' };
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@example.com';
    yourself.
add := LDAPAddRequest new name: 'cn=Doe John,ou=people,dc=example,dc=com'; attributes: attrs.
command := connection request: add.
command wait.

search := LDAPSearchRequest new 
	base: 'ou=people,dc=example,dc=com'; 
	scope: LDAPWholeSubtreeScope new;
	filter: ((LDAPFilter with: 'cn' equalTo: 'Jos') not &
			(LDAPFilter with: 'sn' equalTo: 'Doe')).
command := connection request: search.
command success "last response is just success result code" 
	ifTrue: [ command responses allButLast inspect ]
	ifFalse: [ command signalExceptions ].

connection disconnect.
```

For more documentation see the [core package examples](./md/Core.md) and the [user interface description](./md/Spec.md).

## History

Originally migrated from http://smalltalkhub.com/PharoExtras/LDAP/

