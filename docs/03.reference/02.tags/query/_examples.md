### Simple Example

```lucee+trycf
<cfset qry= queryNew("name,age,whatever", "varchar,date,int", [
[ "Susi", CreateDate( 1970, 1, 1 ), 5 ],
[ "Urs" , CreateDate( 1995, 1, 1 ), 7 ],
[ "Fred", CreateDate( 1960, 1, 1 ), 9 ],
[ "Jim" , CreateDate( 1988, 1, 1 ), 11 ]
])>
<!-- QofQ -->
<cfquery name="selectName" dbtype="query">
	select * from qry where name='jim'
</cfquery>
<cfdump var="#selectName#" />
```