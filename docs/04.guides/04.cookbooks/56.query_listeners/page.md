---
title: Query Listeners
id: cookbook-query-listeners
related:
- tag-application
- tag-query
- function-queryexecute
categories:
- application
- query
description: A query listener is a hook which can be configured to run before and after a query is executed.
---

# Query Listeners in Lucee

A Query Listener is a hook which can be configured to run before and after a query is executed.

This is available as an experimental feature in Lucee 5.3 and is officially supported in Lucee 6.0.

This allows you to change the query arguments, including the SQL before it executes and then also modify the result before it's returned.

**Remember, when working with the `after()` method, that a query can return a struct or array, not just a query object**

They can be configured:

- application wide, via [[tag-application]] i.e. `Application.cfc`
- per [[tag-query]] or [[function-queryexecute]]

A Query Listener is a component with two methods, `before()` and `after()`. You can have other methods in your listener component, but Lucee will only call these two.

## Examples

i.e. `QueryListener.cfc`

```luceescript
<cfscript>
component {

	function before( caller, args ) {
		dump( var=#arguments#, label="queryListener.before()" );
		args.sql &= " where TABLE_NAME like 'SCH%'"; // modify the sql statement before it executes
		// args.maxrows=2;
		return arguments;
	}

	function after( caller, args, result, meta ) { 
        // remember, result maybe a query, array or struct, check the args!
		dump( var=#arguments#, label="queryListener.after()" );
		// var row=queryAddRow(result);
		// result.setCell("abc","123",row);
		return arguments;
	}
}
</cfscript>
```

To add an Application wide query listener, add the following to your `Application.cfc`

```luceescript
this.query.listener = new QueryListener();
```

To add a query listener to an individual [[tag-query]]

```luceescript
<cfset listener = new QueryListener()>
<cfquery name="qry" datasource="local_mysql" listener=#listener#>
    SELECT  COLUMN_NAME, TABLE_NAME F
    FROM    INFORMATION_SCHEMA.COLUMNS
</cfquery>
```

Or an individual [[function-queryexecute]]

```luceescript
<cfscript>
    qry = queryExecute(
        sql="SELECT COLUMN_NAME, TABLE_NAME
        FROM INFORMATION_SCHEMA.COLUMNS",
        options={
            datasource : "local_mysql",
            listener=new QueryListener()
        }
    );
</cfscript>
````

### Dump of arguments to the query Listener before() method

<img alt="Query Listener Before()" src="/assets/images/listeners/queryListenerBefore.png">

### Dump of arguments to the query Listener after() method (cfquery)

<img alt="Query Listener After()" src="/assets/images/listeners/queryListenerAfter.png">

### Dump of arguments to the query Listener after() method (queryExecute)

<img alt="Query Listener After()" src="/assets/images/listeners/queryListenerAfterNoResult.png">

### Sample query result

<img alt="Query Listener Result" src="/assets/images/listeners/queryListenerResult.png">
