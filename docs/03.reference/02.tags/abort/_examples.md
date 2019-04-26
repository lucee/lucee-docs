### Example for cfabort
```luceescript+trycf
	<cfset setVar = 3> 
	<cfloop from = "1" to = "4" index = "countVar"> 
	  <cfif countVar is 2> 
	    <cfabort/>
	  <cfelse> 
	    <cfset setVar = setVar + 1> 
	  </cfif> 
	</cfloop> 
```