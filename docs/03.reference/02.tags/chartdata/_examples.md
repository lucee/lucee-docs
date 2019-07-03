### Simple example for Chartdata
```lucee+trycf
<cfchart format="jpg" title="Sales Result" backgroundcolor="yellow" showborder="true">
  <cfchartseries type="curve">
    <cfchartdata item="2016" value="#RandRange(100,500)#">
    <cfchartdata item="2017" value="#RandRange(100,500)#">
    <cfchartdata item="2018" value="#RandRange(100,500)#">
    <cfchartdata item="2019" value="#RandRange(100,500)#">
  </cfchartseries>
</cfchart>
```
