---
title: Query Handling In Lucee
id: query-handling-lucee
---

Here we can find how the lucee supports for SQL queries. 

## Query tags ##

```<cfquery>``` different ways to use the tags in lucee & how we can the passed the value into the query

```lucee
<cfquery name="qry" datasource="test">
	select * from Foo1890
</cfquery>
<cfdump var="#qry#" expand="false">
```

Above example just retrieve data from database.


### Using QueryParam ###

Queryparam used inside the query tag, It used to bind the value with sql statement

```lucee
<cfquery name="qry" datasource="test">
	select * from Foo1890
	where title=<cfqueryparam sqltype="varchar" value="Susi">
</cfquery>
<cfdump var="#qry#" expand="false">
```

Passing value with QueryParam, has two advantage,

* Value you passed in queryparam is very secured,
* Lucee able to cache the statement query statement & reused it as long the value changed.

### params ###
Here we use param as part of cfquery tag, used to pass the value with SQL statement.

Pass the params value with struct

```lucee
<cfquery name="qry" datasource="test" params="#{title:'Susi'}#">
	select * from Foo1890
	where title=:title
</cfquery>
<cfdump var="#qry#" expand="false">
```

referenced as ```:key``` in sql.

Below example to pass the more information with struct

```lucee
<cfquery name="qry" datasource="test" params="#{title:{type:'varchar',value:'Susi'}}#">
	select * from Foo1890
	where title=:title
</cfquery>
<cfdump var="#qry#" expand="false">
```

You can passed the params value by array, It referenced as `?` in SQL

```lucee
<cfquery name="qry" datasource="test" params="#['Susi']#">
	select * from Foo1890
	where title=?
</cfquery>
<cfdump var="#qry#" expand="false">
```

Below example to pass the more information with array

```lucee
<cfquery name="qry" datasource="test" params="#[{type:'varchar',value:'Susi'}]#">
	select * from Foo1890
	where title=?
</cfquery>
```

## Query with script tag ##

Lucee supports for two types script statements like below,

```lucee
query name="qry" datasource="test" params={title:{type:'varchar',value:'Susi'}} {
	echo("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
```

```lucee
cfquery(name="qry",datasource="test",params={title:{type:'varchar',value:'Susi'}}) {
	echo("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
```

## QueryExecute ##

It supports for both script tag & regular tag, you can pass all the arguments to the function.

```lucee
qry=queryExecute(
	sql:"select * from Foo1890 where title=:title"
	,options:{datasource="test"}
	,params={title:{type:'varchar',value:'Susi'}}
);
dump(qry);
```

Pass the values in params same as we saw in cfquerytag, In options we can pass other arguments like datasource,cachename,dbtype



### Query Component ###

You can do a query with component like "Query()".

```lucee
<cfscript>
	query=new Query(sql:"select * from Foo1890 where title=?");
	query.setParams([{type:'varchar',value:'Susi'}]);
	query.setDatasource('test');
	dump(query.execute().getResult());
</cfscript>
```

Above example we pass the sql as part with constructor. 
Use setDatasource() function to set the datasource,
Use setParams() function to set the param values, value used same as we see in tag

```query.execute()``` function returns detail of the component, ```query.execute().getResult()``` returns query result.

### Query Future ###
We are always in discussion how to improve the functions in lucee.

Here we use ```$``` instead of writeOutput or echo inside the script using like below

```lucee
<cfscript>
query name="qry" datasource="test" params={title:{type:'varchar',value:'Susi'}} {
	$("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
</cfscript>
```

We can use not only for query, you can use any where in the file ```$("Hi there")``` make our output. This idea to make a code better

lucee supports for static functions, we can use like below code

```lucee
<cfscript>
// Component gets more static functions
q=Query::new("a,b,c");	// equal to queryNew("a,b,c"), already exists
Query::execute(...);	// equal to queryExecute(), coming soon
</cfscript>
```
### Query Builder ###

Query Builder use as extension, it will not come up with core. 

It is much easier to do a simple query.

You can 

```lucee
<cfscript>
// Query Builder (creates SQL in dialect based on the datasource defined)
	qb=new QueryBuilder("test")
		.select("lastName")
		.from("person")
		.where(QB::eq("firstname","Susi"));
	qb.execute();
	dump(res);
</cfscript>
```
Use ```QueryBuilder("test")``` as constructor

* define a datasource with constructor or 'setDatasource('test')' function,
* Use ```select("lastName")``` to select the column
* Use ```from("person")``` from which table you want to retrieve data,
* where statement like ```where(QB::eq("firstname","Susi"))```,

Use ```qb.execute()``` to obtain the result.

You can change selected column like below example

```lucee
<cfscript>
// change select
qb.select(["age","firstname"]);
qb.execute();
dump(res);
</cfscript>
```
You can also change the where condition also like below example

```lucee
<cfscript>
// change where
qb.clear("where");
qb.where(
	QB::and(
		QB::eq("firstname","Susi"),
		QB::neq("lastname","Moser"),
		QB::lt("age",18)
	)
);
qb.execute();
dump(res);
</cfscript>
```

### Footnotes ###

Here you can see above details in video

[Lucee query handling ](https://www.youtube.com/watch?time_continue=684&v=IMdPM58guUQ)



















