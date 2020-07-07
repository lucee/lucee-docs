<cfscript>
    setting requesttimeout="60000";
    logger = new api.build.Logger();
    startTime = getTickCount();
    new api.reference.ReferenceImporter(threads=1).importAll();
</cfscript>
<cfcontent reset="true" type="text/plain">
<cfoutput>---
Reference documentation imported in #NumberFormat( getTickCount()-startTime )#ms
---

</cfoutput>