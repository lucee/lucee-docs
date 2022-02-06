---
title: Query of Queries sometimes it rocks, sometimes it sucks
id: QOQ_Sucks
related:
- tag-query
- function-queryexecute
- function-queryfilter
categories:
- query
---

## The good, the bad and the ugly ##

This document explains why Query of Queries (QoQ) may or not be best approach for your use case.

- **PRO** it's nice to work with in memory datasets/queries using SQL.
- **CON** is can be very slow, depending on the use case.

Update, the performance of QoQ has been dramatically for single tables improved since 5.3.8!

[Improving Lucee's Query of Query Support](http://wwvv.codersrevolution.com/blog/improving-lucees-query-of-query-support)

There has also been a lot of work done, to improve the "correctness" of the native SQL engine's behaviour

[QoQ tickets](https://luceeserver.atlassian.net/issues/?jql=text%20~%20%22qoq%22%20ORDER%20BY%20updated)

Currently, Lucee QoQ only supports `SELECT` statements, `UPDATE` and `INSERT` aren't yet supported.

Lucee has two QoQ engines, a fast native engine which only works on a single table.

Any SQL using a multiple tables, i.e. with a JOIN, will fallback to the HSQLDB engine.

The HSQLDB engine requires loading all the queries into temporary tables and is currently java synchronized, all of which can affect performance.

If the native QoQ engine fails on a single table query, by default, Lucee will attempt to fallback on the HSQLDB engine

 See `LUCEE_QOQ_HSQLDB_DISABLE` and `LUCEE_QOQ_HSQLDB_DEBUG`, under [[running-lucee-system-properties]]

### Example : ###

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
	dump(server.lucee.version);
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
			return (arguments.row.description contains s); // works even better with variables.s in lucee 5.3.3
		});
	</cfscript>
</cftimer>
<cfdump var=#q2.recordcount#>


<cftimer type="outline" label="query.filter() with unscoped variables">
	<cfscript>
		q3 = q.filter(function(row){
			return (row.description contains s);
		});
	</cfscript>
</cftimer>
<cfdump var=#q3.recordcount#>
```

In this example have a QOQ with persons table.

```luceescript
// index.cfm

directory sort="name" action="list" directory=getDirectoryFromPath(getCurrentTemplatePath()) filter="example.cfm" name="dir";
loop query=dir {
	echo('<a href="#dir.name#">#dir.name#</a><br>');
}
```

```luceescript
// example.cfm

max=1000;
persons=query(
	"lastname":["Lebowski","Lebowski","Lebowski","Sobchak"],
	"firstname":["Jeffrey","Bunny","Maude","Walter"]
	);

// Query of Query
start=getTickCount("micro");
loop times=max {
	query dbtype="query" name="qoq" {echo("
		select * from persons
		where lastname='Lebowski'
		and firstname='Bunny'
		order by lastname
	");}
}
dump("Query of Query Execution Time:"&(getTickCount("micro")-start));

// Query Filter/Sort
start=getTickCount("micro");
loop times=max {
	qf=queryFilter(persons,function (row,cr,qry) {return row.firstname=='Bunny' && row.lastname=='Lebowski';});
	qs=querySort(qf,"lastname");
}
dump("Query Filter/Sort Execution Time:"&(getTickCount("micro")-start));

```

In this example have two different methods of queries.

1) First one is QOQ. Here ``QoQ`` from the ``persons`` table. It is executed a thousand times due to the looping required by QoQ.

2) The second one is calling the function query filter. Query filter filters out the same row the same way the QOQ does.

3) Execute it in the browser and we get two results(Query of query execution time and Query filter/sort execution time). Query filter executes twice as fast, at least, as query of query. Because QOQ loops over and over again, it is slower. If you can avoid QOQ and use the Query filter/sort, your code will execute much faster.

### Footnotes ###

You can see these details in the video here:

[Query of Query Sucks](https://www.youtube.com/watch?v=bUBXzo1WbSM)
