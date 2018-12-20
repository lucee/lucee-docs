```lucee+trycf
<cfoutput>
	<cfset expr = 2>
	<cfswitch expression="#expr#">
		<cfcase value=1>
			this is from case 2
		</cfcase>
		<cfcase value=2$3$4 delimiters="$">
			this is from case 2
		</cfcase>
		<cfdefaultcase>
			this is from default part
		</cfdefaultcase>
	</cfswitch>

	<cfscript>
	//Script example
		switch(1){
			case 1:
				result = 1;
				break;
			case 0:
				result = 0;
				break;
			default:
				result = "defaultCase";
		}
		writeDump(result);
	</cfscript>
</cfoutput>
```