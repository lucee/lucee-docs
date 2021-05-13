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
