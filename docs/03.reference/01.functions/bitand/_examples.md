The following code example will output an example numbers returned from the	 bitAnd() function.

```lucee
<cfset inputValue1 = 5>
<cfset inputValue2 = 255>
<cfoutput>#bitAnd(inputValue1, inputValue2)#</cfoutput>
<br>
<cfset inputValue1 = 5>
<cfset inputValue2 = 0>
<cfoutput>#bitAnd(inputValue1, inputValue2)#</cfoutput>
```