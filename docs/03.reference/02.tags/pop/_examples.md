### Action getAll

```lucee
<cfpop action="getAll" username="#username#" password="#password#" server="#server_name#" uid="#uid#" name="res">
<cfdump var="#res#" />

<cfpop action="getAll" username="#username#" password="#password#" server="pop.mail.com" port="995" secure="true" name="message"
maxrows = "15" attachmentpath="#expandpath('./')#">
<cfdump var="#message#" />
```

### Action getHeaderOnly

```lucee
<cfpop action="getHeaderOnly" username="#username#" password="#password#"  server="pop.mail.com" name="getHeader">
<cfdump var="#getHeader#" />
```

### Action delete

```lucee
<cfpop action="delete" username="#username#" password="#password#" server="pop.mail.com" uid="1RaJA7-1ioN2e27mu-00thu">
```