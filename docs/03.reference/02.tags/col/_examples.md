```lucee+trycf
<cfset data = queryNew("id,name,age", "integer,varchar,integer", [
    {id:1,name:"Item1",age:20},
    {id:2,name:"Item2",age:24},
    {id:3,name:"Item3",age:44},
    {id:4,name:"Item4",age:42}
])>
<cfquery name="qryData" dbtype="query">
    SELECT *
    FROM data
</cfquery>
<cftable query="qryData" startRow="1" colSpacing="3"  border=true  HTMLTable colHeaders>
    <cfcol header="<b>Id</b>" align="Left" width="15" text="#id#">
    <cfcol header="<b>Name</b>" align="Left" width="15" text="#name#">
    <cfcol header="<b>Age</b>" align="Left" width="15" text="#age#">
</cftable>
```