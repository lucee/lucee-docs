
```lucee+trycf
<cfset intA = 1>
<cfsilent>
	<cfset intA =intA+10 >
	<cfdump var="#intA#" /> 
</cfsilent>
<cfdump var="#intA#" />

<cfscript>
// Using cfscript
	isExecuted=false;
	silent {
		writeoutput("text");
		isExecuted=true;
	writeDump("Inside dump executed: "&isExecuted);
	}
	writeDump("Outside dump executed: "&isExecuted); 
</cfscript>
```