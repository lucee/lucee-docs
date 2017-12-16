```luceescript+trycf
<cfset testCondition = true>
<cfset cnt = 0>
<cfwhile condition="#testCondition#">
    <cfset cnt = cnt + 1>
    <cfif cnt EQ 5>
        <cfset testCondition = false>
    </cfif>
</cfwhile>
<cfoutput>#cnt#</cfoutput>
 ```

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
