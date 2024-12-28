
# LDAP User Interfaces

The `LDAP-Spec2` package contains several Spec presenters and applications to browse and edit LDAP data.

## Browser

The LDAP browser uses the traditional Smalltalk [Miller column widget](https://en.wikipedia.org/wiki/Miller_columns) (like the inspector) to show the entries of the LDAP server.

Selecting an sub-entry (represented with a folder icon) will show its attributes in a new column on its right.

![LDAPInspectorPresenter](./images/LDAPBrowser.png)

On top, you can open the server settings dialog and select one of the roots published by the server. At the bottom, you can see the connection status and quit the current server.

## Connection

The LDAP server can be selected by clicking the `home` icon on the browser window.

![LDAPConnectionPresenter](./images/LDAPConnectionPresenter.png)

When `OK` is clicked in this dialog, a new LDAP connection is opened and the available root distinguished names (also called naming contexts) are requested. The first one is chosen and the entries are then displayed.
