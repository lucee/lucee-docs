<cfscript>
    setting requesttimeout="60000";
    logger = new api.build.Logger({textOnly: true});

    request.loggerFlushEnabled = true;
    startTime = getTickCount();
    new api.reference.ReferenceImporter(threads=1).importAll();
    //content reset="true" type="text/plain";
</cfscript>
<cfoutput>---
Reference documentation imported in #NumberFormat( getTickCount()-startTime )#ms
---

</cfoutput>