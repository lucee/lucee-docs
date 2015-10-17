### Tags
```lucee
<cfstopwatch variable="stopwatchVar">
    <cfset i = 0>
    <cfloop from="1" to="10000" index="j">
        <cfset i++>
    </cfloop>
</cfstopwatch>

<cfdump var="#variables.stopwatchVar#">
```

### Script
```luceescript
stopwatch variable="stopwatchVar" {
    i = 0;
    loop from="1" to="10000" index="j" {
        i++;
    }
    dump(variables.stopwatchVar)
}
```
