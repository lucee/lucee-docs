### Example for Mailpart

```lucee
<cfmail from="test@gmail.com" to="chk@gmail.com" subject="Testing emailpart" server="localhost">
  <cfmailpart type="text/plain"/>
    <cfoutput>This is test of cfmailpart</cfoutput>
</cfmail>
```