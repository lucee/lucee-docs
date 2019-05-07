### Tag format
```lucee+trycf
<cfif isArray(SERVER)>
	<cfset result="It is in Array format">
<cfelseif(isStruct(SERVER))>
	<cfset result="It is in Structure format">
<cfelse>
	<cfset result ="Other than struct & Array" >
</cfif>
<cfdump var="#result#" /> 
```
### Script format
```luceescript+trycf
<cfscript>
	//script format
	numb=1
	if(numb gt 1){
		writeOutput("It is greater than 1 ");
	}else if(numb eq 1){
		writeOutput("It is equal to 1 ");
	}else{
		writeOutput("It is not greater than or equal to 1 ");
	}
</cfscript>
```