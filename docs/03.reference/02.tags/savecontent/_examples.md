```lucee+trycf
<cfoutput>
	<cfsavecontent variable="test">
		Here you can add any cf, HTML elements etc.,
		Where you need it just place the variable of cfsavecontent, automatically shows the content stored here.
	</cfsavecontent>
	<cfsavecontent variable="example">
		<br>
		<input type="text" name="textfield">
	</cfsavecontent>
	#test#
	#example#
</cfoutput>
```

```luceescript+trycf
	cfsavecontent( variable="test" ){
		echo("Here you can add any cf, HTML elements etc.,");
	}
	echo(test);
```
