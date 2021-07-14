### Simple example for cfmail

```lucee
<cftry>
 	<cfmail from="aaa@bb.com" to="test01@mail.com" subject="sample" cc="test02@gmail.com" server="example.mail.com">
		Test Email
	</cfmail>
	<cfcatch>
		<cfdump var="#cfcatch.message#">
	</cfcatch>
</cftry>
```