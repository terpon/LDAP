# Example Snippets

## Establish a connection to the LDAP server
```Smalltalk
| connection bind command |
connection := (LDAPConnection to: 'ldap.example.com' port: 389).
bind := LDAPBindRequest new username: 'cn=admin,dc=example,dc=com'; password: 'password'.
command := connection request: bind.
command wait.
```

## Establish a connection to the LDAP server with SSL
Use a `LDAPSConnection` instance for the connection.
```Smalltalk
| connection bind command |
connection := LDAPSConnection to: 'ldaps.example.com' port: 636.
bind := LDAPBindRequest new username: 'cn=admin,ou=people,dc=example,dc=com'; password: 'password'.
command := connection request: bind.
command wait.
command success ifFalse: [ command signalExceptions ]
```


### Create a new entry
```Smalltalk
| attrs add command |
attrs := Dictionary new
    at: 'objectClass' put: { 'inetOrgPerson' };
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@domain.org';
    yourself.

add := LDAPAddRequest new name: 'cn=Doe John,ou=people,dc=example,dc=com'; attributes: attrs.
command := connection request: add.
command wait.
```

### Change the value of an attribute
```Smalltalk
| mod command |
mod := LDAPModifyRequest new name: 'uid=jdoe,ou=people,dc=example,dc=com'.
mod set: 'sn' to: 'Doe'.
command := connection request: mod.
command wait.
```

### Add an attribute
```Smalltalk
| mod command |
mod := LDAPModifyRequest new name: 'uid=jdoe,ou=people,dc=example,dc=com'.
mod description: 'loginShell' add: '/bin/bash'.
mod description: 'group' add: { 'audio'. 'test' }.
command := connection request: mod.
command wait.
```

### Read all entries
```Smalltalk
| command search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=example,dc=com'; 
	scope: LDAPWholeSubtreeScope new; 
	derefAliases: LDAPNeverDeferAliases new.
command := connection request: search.
resultEntries := command reponses. "Wait and return a collection of LDAPSearchResultEntry instances"
```

### Select entries with filters
```Smalltalk
| command search resultEntries |
search := LDAPSearchRequest new 
	base: 'ou=people,dc=example,dc=com'; 
	scope: LDAPWholeSubtreeScope new;
	filter: ((LDAPFilter with: 'cn' equalTo: 'Jos') not &
			(LDAPFilter with: 'sn' equalTo: 'Doe')).
command := connection request: search.
resultEntries := command responses.
```

### Delete an entry
```Smalltalk
| command del |
del := LDAPDeleteRequest new name: 'uid=doe,ou=people,dc=example,dc=com'.
command := connection request: del.
command wait.
```

### Disconnect the client
```Smalltalk
connection disconnect
```
