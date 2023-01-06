<cfscript>
    setting requesttimeout="60000";
    logger = new api.build.Logger(opts:{textOnly: true, console: true}, force:true);
    request.loggerFlushEnabled = true;
    logger.logger( "Lucee " & server.lucee.version & ", java " & server.java.version );
    startTime = getTickCount();
    new api.reference.ReferenceImporter(threads=1).importAll();
    //content reset="true" type="text/plain";
    logger.logger( "Reference documentation imported in #NumberFormat( getTickCount()-startTime )#ms" );
    logger.logger(" ");
</cfscript>
<cfoutput>---
Reference documentation imported in #NumberFormat( getTickCount()-startTime )#ms
---

</cfoutput>