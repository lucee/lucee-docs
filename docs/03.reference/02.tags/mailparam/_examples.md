### Simple example for cfmailparam

```lucee
<cftry>
	<cfmail from="sender@example.com" to="receiver@example.com" subject="mailparam example" server="smtp.gmail.com">
		<cfmailparam name="header" value="Mail header">
		Mailparam header example
	</cfmail>
	<cfcatch>
		<cfdump var="#cfcatch.message#" />
	</cfcatch>
</cftry>
```