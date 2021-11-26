### Tags

```lucee+trycf
<cfset qry= queryNew("name,age,whatever", "varchar,date,int", [
[ "Susi", CreateDate( 1970, 1, 1 ), 5 ],
[ "Urs" , CreateDate( 1995, 1, 1 ), 7 ],
[ "Fred", CreateDate( 1960, 1, 1 ), 9 ],
[ "Jim" , CreateDate( 1988, 1, 1 ), 11 ]
])>
<!-- bad example, not using a bound parameter, unsafe when using input from users -->
<cfquery name="q" dbtype="query">
	select * from qry where name = 'jim'
</cfquery>
<cfdump var="#q#" />

<!-- using a bound parameter with cfqueryparam -->
<cfquery name="q" dbtype="query">
	select * from qry where name = <cfqueryparam value='jim'>
</cfquery>
<cfdump var="#q#" />

<!-- using an array of simple params -->
<cfscript>
    p = [ 'jim' ];
</cfscript>
<cfquery name="q" dbtype="query" params=#p#>
	select * from qry where name = ?
</cfquery>
<cfdump var="#q#" />

<!-- using an array of struct params -->
<cfscript>
    p = [ { value='jim', sqltype='varchar' } ];
</cfscript>
<cfquery name="q" dbtype="query" params=#p#>
	select * from qry where name = ?
</cfquery>
<cfdump var="#q#" />

<!-- using an array of named struct params -->
<cfscript>
    p = [id= { value='jim', sqltype='varchar' } ];
</cfscript>
<cfquery name="q" dbtype="query" params=#p#>
	select * from qry where name = :id
</cfquery>
<cfdump var="#q#" />
```

### Script

```luceescript+trycf
  qry= queryNew("name,age,whatever", "varchar,date,int", [
    [ "Susi", CreateDate( 1970, 1, 1 ), 5 ],
    [ "Urs" , CreateDate( 1995, 1, 1 ), 7 ],
    [ "Fred", CreateDate( 1960, 1, 1 ), 9 ],
    [ "Jim" , CreateDate( 1988, 1, 1 ), 11 ]
    ])

	query name="q" dbtype="query" {
	echo("select * from qry where name = 'jim'");
	}
	writedump(q);

	query name="q" dbtype="query" {
	echo("select * from qry where name = ")
	queryParam cfsqltype="cf_sql_varchar" value="jim";
	}
	writedump(q);

	p = [ 'jim' ];
	query name="q" dbtype="query" params=#p#{
	echo("select * from qry where name = ?");
	}
	writedump(q);

 	p = [id= { value='jim', sqltype='varchar' } ];
	query name="q" dbtype="query" params=#p#{
	echo("select * from qry where name = :id");
	}
	writedump(q);
```
