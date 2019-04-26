### Simple Example
```luceescript+trycf
	<cftry>
	  <cfthrow message="test exception"> 
	  <cfcatch name="test" type="any">
	    <cfdump var="#cfcatch#">
	  </cfcatch>
	</cftry>
```
