```luceescript
<cfquery datasource="UserDB" name='qUser'>
	Select Username, FirstName, LastName
	From UserDB.User
</cfquery>

<cfloop query='qUser'>
	<cfoutput>
		#Username# - #FirstName# - #LastName# <br/>
	</cfoutput>
</cfloop>
```
