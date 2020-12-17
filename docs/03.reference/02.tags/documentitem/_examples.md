### Simple example for cfdocumentitem

```lucee
<cfdocument format="pdf">
	<h1>Welcome to Lucee</h1>
	<h5>Example Page</h5>
	<p>Example for <b>CfdocumentItem</b></p>
	<cfdocumentitem type="header">
		<h2><i>Example Header</i></h2>
	</cfdocumentitem>	
	<cfdocumentitem type="footer">
		<h2><i>Example footer</i></h2>
	</cfdocumentitem>
</cfdocument>
```