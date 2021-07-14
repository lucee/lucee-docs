```lucee+trycf
<cfset expr = 2>
<cfswitch expression="#expr#">
    <cfcase value=1>
        this is from case 1
    </cfcase>
    <cfcase value=2$3$4 delimiters="$">
        this is from case 2
    </cfcase>
    <cfdefaultcase>
        this is from default part
    </cfdefaultcase>
</cfswitch>

<cfscript>
    switch(1){
        case 1:
            result = 1;
            break;
        case 0:
            result = 0;
            break;
        default:
            result = "defaultCase";
    }
    dump( result );
</cfscript>
```