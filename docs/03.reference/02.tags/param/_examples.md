### Simple Example

```lucee+trycf
<cfparam name="FORM.test" default="1">
<cfif FORM.test EQ '1'>
    <cfset isError = false>
<cfelse>
  <cfset isError = true>
</cfif>
<cfoutput>#isError#</cfoutput>
```