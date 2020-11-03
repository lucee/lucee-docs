### Action getAll

```lucee
<cfimap
	action="getAll"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#"
	name="getAll" maxrows ="10" attachmentpath="#expandpath('./')#" generateuniquefilenames="true">
<cfdump var="#getAll#" />
```

### Action getHeaderOnly

```lucee
<cfimap
	action="getHeaderOnly"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#"
	name="getHeader" maxrows ="10">
<cfdump var="#getHeader#" />
```

### Action CreateFolder

```lucee
<cfimap
	action="CreateFolder"
	folder="NewFolderFromIMAP_Test"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#"
	name="CreateFolder">
```

### Action ListAllFolders

```lucee
<cfimap
	action="ListAllFolders"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#"
	name="ListAllFolders" maxrows ="10">
<cfdump var="#ListAllFolders#" />
```

### Action renamefolder

```lucee
	<cfimap
	action="renamefolder"
	folder="NewFolderFromIMAP_Test"
	newFolder="RenameFolderFromIMAP"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#">
```

### Action deletefolder

```lucee
	<cfimap
	action="deletefolder"
	folder="NewFolderFromIMAP_Test"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#"
	maxrows ="10">
```

### Action MoveMail

```lucee
<cfimap
	action="MoveMail"
	Newfolder="newfolder"
	messagenumber ="1"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#">
```

### Action MarkRead

```lucee
<cfimap
	action="MarkRead"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#">
```

### Action open

```lucee
<cfimap
	action="open"
	connection="openConnc"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#">
```

### Action close

```lucee
<cfimap action="close" connection="openConnc">
```

### Action Delete

```lucee
<cfimap
	action="delete"
	folder=""
	messagenumber ="1"
	server="#Imap.Server#"
	port="#Imap.Port#"
	username="#Imap.Username#"
	password="#Imap.Password#"
	secure="#Imap.Secure#">
```