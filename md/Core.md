# Example Snippets

## Connection

### Establish a connection to the LDAP server
```Smalltalk
| connection bind command |
connection := (LDAPConnection to: 'ldap.example.com' port: 389).
bind := LDAPBindRequest new username: 'cn=admin,dc=example,dc=com'; password: 'password'.
command := connection request: bind.
command wait.
```

### Establish a connection to the LDAP server with SSL
Use a `LDAPSConnection` instance for the connection.
```Smalltalk
| connection bind command |
connection := LDAPSConnection to: 'ldaps.example.com' port: 636.
bind := LDAPBindRequest new username: 'cn=admin,ou=people,dc=example,dc=com'; password: 'password'.
command := connection request: bind.
command wait.
command success ifFalse: [ command signalExceptions ]
```

### Disconnect the client
This will send the `LDAPUnbindRequest` which has no response and should only be followed by closing the network socket.
```Smalltalk
connection disconnect
```

## Directory Entry Operations

### Create a new entry
```Smalltalk
| attrs add command |
attrs := Dictionary new
    at: 'objectClass' put: { 'inetOrgPerson' };
    at: 'cn' put: 'Doe John';
    at: 'sn' put: 'Doe';
    at: 'mail' put: 'john.doe@example.com';
    yourself.

add := LDAPAddRequest new name: 'cn=Doe John,ou=people,dc=example,dc=com'; attributes: attrs.
command := connection request: add.
command wait.
```

### Delete an entry
```Smalltalk
| command del |
del := LDAPDeleteRequest new name: 'uid=doe,ou=people,dc=example,dc=com'.
command := connection request: del.
command wait.
```

### Rename an entry
```Smalltalk
| modify command |
modify := LDAPModifyNameRequest new name: 'cn=Doe John,ou=people,dc=example,dc=com';
		newRelativeName: 'cn=Doe Jane';
		dropRelativeName.

command := connection request: modify.
command wait.
```

### Move an entry
```Smalltalk
| modify command |
modify := LDAPModifyNameRequest new name: 'cn=Doe John,ou=deptA,ou=people,dc=example,dc=com';
		newRelativeName: 'cn=Doe Jane';
		underName: 'ou=deptB,ou=people,dc=example,dc=com'.

command := connection request: modify.
command wait.
```

## Entry Attributes Operations

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

### Delete attribute values
```Smalltalk
| mod command |
mod := LDAPModifyRequest new name: 'uid=jdoe,ou=people,dc=example,dc=com'.
mod delete: 'loginShell'.
mod description: 'group' delete: { 'audio' }.
command := connection request: mod.
command wait.
```

## Search Operations

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
