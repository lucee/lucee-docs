```lucee
<cfset mydate = createDate(year(now()), month(now()), day(now()))>

<cfoutput>
The date is #dateFormat(myDate, "dddd, d mmmm yyyy")#.
</cfoutput>
```