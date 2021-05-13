```lucee+trycf
<cfset result =testFun() >
<cfdump var="#result#" />
<cffunction name="testFun" returntype="any">
	<cfset str="I Love Lucee!">
	<cfreturn str>
</cffunction>
```
