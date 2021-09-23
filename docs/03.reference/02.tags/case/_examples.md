```lucee+trycf
<!--- Tag syntax --->
<cfset expr = 2>
<cfswitch expression="#expr#">
    <cfcase value=1>
        this is from case 1
    </cfcase>
    <cfcase value=2$3$4 delimiters="$">
        this is from case 2
    </cfcase>
    <cfcase value=5,6,7>
        this is from case 3
    </cfcase>
    <cfdefaultcase>
        this is from default part
    </cfdefaultcase>
</cfswitch>

<!--- Script syntax --->
<cfscript>
    expr = 1;
    switch(expr){
        case 1:
            result = 1;
            break;
        case 2: 
        case 3:
            result = "2 or 3";
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
