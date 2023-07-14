```lucee+trycf
<cfset dateTimeVar = #dateTimeFormat(now(), "yyyy.MM.dd HH:nn:ss ")# />
<cfoutput>
	<div> #dateTimeVar.parseDateTime()# </div>
</cfoutput>
```