### Tag example

```lucee+trycf
<cfset intA = 1>
<cfsilent>
	<cfset intA =intA+10 >
	<cfdump var="#intA#" />
</cfsilent>
<cfdump var="#intA#" />
```

### Script example

```luceescript+trycf
	isExecuted=false;
	silent {
		writeoutput("text");
		isExecuted=true;
		writeDump("Inside dump executed: "&isExecuted);
	}
	writeDump("Outside dump executed: "&isExecuted);
```

### Cfsilent bufferoutput attribute example

```lucee+trycf
<h4>cfsilent bufferoutput=true</h4>
<cftry>
    <cfsilent bufferoutput="true">
        <cfset s = "the output before the exception must show with bufferoutput=true">
        <cfoutput>#s#</cfoutput>
        <cfthrow type="error">
    </cfsilent>
    <cfcatch>
        <br>  
        <cfoutput>from the cfcatch</cfoutput>
    </cfcatch>
</cftry>
<hr>

<h4>cfsilent bufferoutput=false</h4>
<cftry>
    <cfsilent bufferoutput="false">
        <cfset s = "the output before the exception must not show with bufferoutput=false">
        <cfoutput>#s#</cfoutput>
        <cfthrow type="error">
    </cfsilent>
    <cfcatch>
        <br>  
        <cfoutput>from the cfcatch</cfoutput>
    </cfcatch>
</cftry>

```