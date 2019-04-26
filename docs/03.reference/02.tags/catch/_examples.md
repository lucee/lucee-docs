### Simple example with cfcatch
```luceescript+trycf
<cftry>
  <cfset a = 3/0>
  <cfdump var="#c#" />  
  <cfcatch>
    <cfdump var="#cfcatch#">
  </cfcatch>
</cftry>
```