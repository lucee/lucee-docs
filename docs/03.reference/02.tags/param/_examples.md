### Simple Example

```lucee+trycf
<cfparam name="FORM.test" default="1">
<cfif FORM.test EQ 1>
  <cfloop index="x" from="1" to="3" endRow="1">
    <cfset Content = "X" & #x#>
    <cfset isError = false>
  </cfloop>
<cfelse>
  <cfset isError = true>
</cfif>
<cfoutput>#isError#</cfoutput>
```
