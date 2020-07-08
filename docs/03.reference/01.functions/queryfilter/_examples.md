```luceescript+trycf
people = QueryNew( "name,dob,age", "varchar,date,int", [
    [ "Susi", CreateDate( 1970, 1, 1 ), 0 ],
    [ "Urs" , CreateDate( 1995, 1, 1 ), 0 ],
    [ "Fred", CreateDate( 1960, 1, 1 ), 0 ],
    [ "Jim" , CreateDate( 1988, 1, 1 ), 0 ]
]);

Dump( var=people, label="people - origional query" );

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 0   |
| Urs  | 1995-01-01 00:00:00 | 0   |
| Fred | 1960-01-01 00:00:00 | 0   |
| Jim  | 1988-01-01 00:00:00 | 0   |
*/

//filter - older than 21
qryPeopleOldEnough = people.filter(function(row, rowNumber, qryData){
    return DateDiff('yyyy', row.dob, Now()) > 21
});
dump(var=qryPeopleOldEnough, label='qryPeopleOldEnough - older than 21');

/* Output:

| name | dob                 | age |
------------------------------------
| Susi | 1970-01-01 00:00:00 | 0   |
| Fred | 1960-01-01 00:00:00 | 0   |
| Jim  | 1988-01-01 00:00:00 | 0   |
*/
```

```lucee+trycf
<cfscript>
	q = QueryNew("name, description");
	loop times=3 {
		getFunctionList().each(function(f){
			var fd = getFunctionData(arguments.f);
			var r =QueryAddRow(q);
			QuerySetCell(q,"name", fd.name, r);
			QuerySetCell(q,"description", fd.description, r);
		});
	}
	dump(var=q.recordcount,
	    label="demo data set size");
	s = "the";
</cfscript>

<cftimer type="outline" label="Query of Query">
	<cfquery dbtype="query" name="q1">
		select 	name, description
		from 	q
		where 	description like <cfqueryparam value='%#s#%' cfsqltype="varchar">
	</cfquery>
</cftimer>
<cfdump var=#q1.recordcount#>

<cftimer type="outline" label="query.filter() with scoped variables">
	<cfscript>
		q2 = q.filter(function(row){
			return (arguments.row.description contains s);
		});
	</cfscript>
</cftimer>
<cfdump var=#q2.recordcount#>

<cftimer type="outline" label="query.filter() without unscoped variables">
	<cfscript>
		q3 = q.filter(function(row){
			return (row.description contains s);
		});
	</cfscript>
</cftimer>
<cfdump var=#q3.recordcount#>

```