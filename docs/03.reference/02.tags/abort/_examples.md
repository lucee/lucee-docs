```lucee+trycf
<cfset v = 3>
<cfloop from="1" to="4" index="c">
    <cfif c is 2>
        aborted
        <cfabort>
    <cfelse>
        <cfset v = v + 1>
    </cfif>
    <cfoutput>c: #c#, v: #v#<br></cfoutput>
</cfloop>
<hr>
<cfoutput>c: #c#, v: #v#</cfoutput>
<br>
not aborted
```
