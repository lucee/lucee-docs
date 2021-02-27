```lucee+trycf
	<cfdump var="#getTimeZone()#">
	<cfset settimezone("ART")>
	<cfdump var="#getTimeZone()#">

```