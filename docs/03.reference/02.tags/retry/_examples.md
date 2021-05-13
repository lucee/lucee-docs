```lucee+trycf
<cfoutput>
	<cfset counter = 1>
	Firing http call in thread, so on first try we may not get the result<br>
	<cfthread name="httpCall" action="run">
		<cfhttp url="https://en.wikipedia.org/wiki/2015_in_film" result="thread.httpWikiResult">
		</cfhttp>
	</cfthread>
	<cftry>
		<cfdump var="#httpCall.httpWikiResult.filecontent#" label="http result" />
		<cfcatch>
			#cfcatch.message#<br>
			Waiting for 1 second and retrying<br>
			<cfthread action="sleep" duration="1000" />
			<cfset counter += 1>
			<cfif counter LTE 5> <!--- You may want to limit the number of retry, because hard error may lead to infinite loop --->
				<cfretry />
			</cfif>
		</cfcatch>
	</cftry>
</cfoutput>
```
