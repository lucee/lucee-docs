<!--
{
  "title": "Query return type",
  "id": "query-return-type",
  "categories": [
    "query"
  ],
  "description": "This document explains the different return types for a query with some examples.",
  "keywords": [
    "Query return type",
    "Array return type",
    "Struct return type",
    "Foreign key",
    "Lucee"
  ],
  "related": [
    "tag-query"
  ]
}
-->

# Query return type

Queries can return results as query objects (default), arrays of structs, or structs keyed by a column.

## Default Query Return Type

```luceescript
query name="qry" datasource="test" {
	echo("
		select lastname,firstname from person
	");
}
dump(qry);
```

In this example we have a select statement with two columns in the `person` table. Execute the query in the browser and we get a simple result.

## Array Return Type

Lucee can define the return type in a query tag. If we set array as follows: `returntype="array"`. We will get the result as an array.

```luceescript
query name="arr" datasource="test" returntype="array" {
	echo("
		select lastname,firstname from person
	");
}
dump(arr);
```

In this array, for each row there is an item in the array and it has a struct with all the columns. So this array is special because it returns an array of structs, and it has meta information about the SQL statement. So it shows the record count and execution time of the query.

## Struct Return Type

This example shows the same concepts that were shown in the previous Example 2, however instead of an array, we can do a struct. If you want to have a struct result, set the return type as struct.

```luceescript
query name="sct" datasource="test" returntype="struct" columnKey="lastname" {
	echo("
		select lastname,firstname from person
	");
}
dump(sct);
```

1. In this case you have to define which column is the key of the struct. Here I simply use the last name as the key of the struct.

2. Execute it in the browser, and we get a struct as a result and the key is the last name. So you can directly choose one of these elements by writing the lastname.

## Using Struct Return Type with Foreign Keys

```luceescript
if(isNull(application.sex)) {
	query name="application.sex" datasource="test" returntype="struct" columnKey="sex_id" {
		echo("
			select sex_id,name from sex
		");
	}
}
query name="qryPerson" datasource="test" {
	echo("
		select sex_id,lastname,firstname from person
	");
}
loop query=qryPerson {
	dump(qryPerson.lastname&" "&qryPerson.firstname&" ("&application.sex[qryPerson.sex_id].name&")");
}
```

1. In this example we have two tables. We make a query to the `person` table. Notice that some fields are foreign key references too. We store `sex_id` in the application scope because we use this in the second query. In this, `sex_id` is the key of that struct, so we can simply address it in `"(&application.sex[qryPerson.sex_id].name&")"` this way.

2. Execute this example in the browser and we get a result from the other table that is referenced by a foreign key.

## Footnotes

You can see these details in the video here:

[Query return type](https://www.youtube.com/watch?v=b9YHhnAuNiw)
