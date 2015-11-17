```luceescript+trycf
<cfsilent>
  <cfset count = 0 />

  <cfloop from="1" to="10" index="x">
    <cfif x is 5>
      <cfcontinue />
    </cfif>

    <cfset count++ />
  </cfloop>
  
  <cfdump var="#count#" label="Count variable" abort />
</cfsilent>
```
