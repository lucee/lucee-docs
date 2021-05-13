```lucee+trycf
<cfloop from=1 to="10" index="i">
	<cfdump var="#i#" />
	<cfif i Eq 5>
		<cfexit>
	</cfif>
</cfloop>
```
