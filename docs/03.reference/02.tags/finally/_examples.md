```lucee+trycf
<cftry>
  <cfset a = 2/0>
  <cfdump var="#a#" />
  <cfcatch type="any">
    Caught an error.
  </cfcatch>
  <cffinally>
    This is from cffinally.
  </cffinally>
</cftry>
```
