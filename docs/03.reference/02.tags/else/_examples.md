### Simple Example with tag format
```lucee+trycf
<cfif isArray(SERVER)>
	<cfset result="It is in Array format" >
<cfelse>
	<cfset result="It is not in Array format" >
</cfif>
<cfdump var="#result#" /> 
```

### Simple example with script format
```luceescript+trycf
	//script format
	numb=1
	if(numb gt 1){
		writeOutput("It is greater than 1 ");
	}else{
		writeOutput("It is not greater than 1 ");
	}
```