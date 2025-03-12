```luceescript+trycf
testCondition = true;
cnt = 0;
while(testCondition) {
    cnt = cnt + 1;
    if (cnt EQ 5) {
        testCondition = false;
    }
}
echo(cnt);
```

```luceescript+trycf
<!--- testing condition  --->
<cfset testCondition = true>
<cfset cnt = 0>
<cfloop condition="#testCondition#">
    <cfset cnt = cnt + 1>
    <cfif cnt EQ 5>
        <cfset testCondition = false>
    </cfif>
</cfloop>
<cfoutput>#cnt#</cfoutput>
```

```luceescript+trycf
// breaking out using a label
x = 0;
WhileLabel: while (x < 10){
    writeOutput("x is #x#<br>");
    switch (x){
        case 1:
            break;
        case 3:
            break WhileLabel;
    }
    x++;
    writeOutput("end of loop<br>");
}
writeOutput("After loop, x is #x#<br>");
```

```luceescript+trycf
<!--- breaking out using a label ---> 
<cfset x = 0>
<cfloop condition="x LT 10" index="i" label="WhileLabel">
    <cfoutput>x is #x#<br></cfoutput>
    <cfswitch expression="#x#">
        <cfcase value="1">
            <cfbreak>
        </cfcase>
        <cfcase value="3">
            <cfbreak loop="WhileLabel">
        </cfcase>
    </cfswitch>
    <cfset x = x + 1>
    <cfoutput>end of loop<br></cfoutput>
</cfloop>
<cfoutput>After loop, x is #x#<br></cfoutput>
```
