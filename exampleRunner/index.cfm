<cfparam name="form.lang">
<cfparam name="form.codeKey">

<cfscript>
    // only reachable via internalRequest
    if (len(cgi.HTTP_USER_AGENT?:"") eq 0 && structKeyExists(server, "_luceeExamples_#form.codeKey#")){
        src = server["_luceeExamples_#form.codeKey#"];
        structDelete(server, "_luceeExamples_#form.codeKey#");
        try {
            if (form.lang eq "cfs"){
                echo( render( "<cfscript> #src##chr(10)#</cfscript>" ) );
            } else {
                echo( render( src ) );
            }
        } catch(e){
            //dump(arguments);
            //dump(src);
            header statuscode="500";
            echo(e.message);
            //abort;
        }
    }
</cfscript>
