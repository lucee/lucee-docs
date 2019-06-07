```lucee+trycf
<cfcache action='cache' timespan='#createTimeSpan( 0, 0, 0, 5 )#' idletime='#createTimeSpan( 0, 12, 0, 0 )#'>
  <cfdump var="#now()#" />
</cfcache>
```