```lucee+trycf
<cftry>
  <cfoutput>#non_existant_variable#</cfoutput>
  <cfcatch name="alt">
    <cfdump var=#alt#>
  </cfcatch>
</cftry>
```