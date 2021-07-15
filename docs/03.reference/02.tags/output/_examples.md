### Simple example

```lucee+trycf
<cfset a=3>
<cfset b=8>
<cfloop index="i" from="#a#" to="#b#">
  <cfoutput>#i#</cfoutput>
</cfloop>
<br>
<cfset test = queryNew("name,age","varchar,numeric",{name:["Susi","Urs","john","jerry"],age:[20,20,28,32]})>
<cfoutput query="test" maxrows="3">
	#test.name#
	#test.age#
</cfoutput>
<br>
<cfoutput query="test" startrow="2" endrow="3">
	#test.name#
	#test.age#
</cfoutput><br>
<br>
<cfoutput query="test" group="age">
	#test.name#
	#test.age#
</cfoutput>
```