The following examples tests a boolean and non-boolean variable using the isBoolean() and outputs the return.

```lucee
<cfset booleanValue = true>
<cfset stringValue = "Hello World">
<cfset numericValue = 10>
<cfset anArray = []>
<cfset aStruct = {}>
<cfoutput>
	Boolean Value: #isBoolean(booleanValue)#<br>
	String Value: #isBoolean(stringValue)#<br>
	Numeric Value: #isBoolean(numericValue)#<br>
	An Array: #isBoolean(anArray)#<br>
	A Structure: #isBoolean(aStruct)#<br>
</cfoutput>
```