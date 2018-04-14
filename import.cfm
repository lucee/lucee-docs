<cfsetting requesttimeout="60000" />
<cfset startTime = getTickCount()>
<cfset new api.reference.ReferenceImporter(threads=4).importAll() />
<cfcontent reset="true" type="text/plain">
<cfoutput>---
Reference documentation imported in #NumberFormat( getTickCount()-startTime )#ms
---

</cfoutput>