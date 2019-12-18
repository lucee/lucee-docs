### Exmaple for cfchart
```lucee+trycf
<cfchart format="jpg" title="Sales Report" backgroundcolor="cyan" showborder="true">
  <cfchartseries type="pie" >
    <cfchartdata item="2012" value="2000">
    <cfchartdata item="2013" value="4000">
    <cfchartdata item="2014" value="5000">
    <cfchartdata item="2015" value="7000">
  </cfchartseries>
</cfchart>
```