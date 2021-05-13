
```lucee+trycf
<cfoutput>
	<cfset myArray=ArrayNew(1)>
	<cfloop index="i" from="1" to="4">
		<cfset myArray[i]="This is array element" & i>
	</cfloop>
	<b>The output of ToScript(myArray, "jsVar")</b><br>
	#ToScript(myArray, "jsVar")#<br>
	<b>In a JavaScript script, convert thisString Variable to JavaScript
	and output the resulting variable:</b><br>
	<script type="text/javascript" language="JavaScript">
			var #ToScript(myArray, "jsVar")#;
			for (i in jsVar) {
			document.write("jsVar in JavaScript is: " + jsVar[i] + "<br>");
		}
	</script>
</cfoutput>

```
