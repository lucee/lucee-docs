### Chartseries Example
```lucee+trycf
<cfchart format="jpg" title="Sales Result" backgroundcolor="magenta" showborder="true">
  <cfchartseries type="bar" paintstyle="light">
    <cfchartdata item="2016" value="100">
    <cfchartdata item="2017" value="300">
    <cfchartdata item="2018" value="500">
    <cfchartdata item="2019" value="700">
  </cfchartseries>
</cfchart>
```