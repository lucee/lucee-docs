```lucee
<cfset mydate = createDateTime(year(now()), month(now()), day(now()), hour(now()), minute(now()), second(now()))>

<cfoutput>
The time is #timeFormat(myDate, "HH:MM:ss")# on #dateFormat(myDate, "dddd, d mmmm yyyy")#.
</cfoutput>
```