```lucee+trycf
<cfoutput>
	<cfsavecontent variable="test">
		Here you can add any cf, html elements etc.,
		Where you need it just place the variable of cfsavecontent, automatically shows the content stored here.
	</cfsavecontent>
	<cfsavecontent variable="example">
		<br>
		<input type="text" nmae="textfield">
	</cfsavecontent>
	#test#
	#example#
</cfoutput>
#test#
```