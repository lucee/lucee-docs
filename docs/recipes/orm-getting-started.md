<!--
{
  "title": "ORM - Getting Started",
  "id": "orm-getting-started",
  "categories": [
    "orm"
  ],
  "description": "Quick start guide to using ORM in Lucee: enable ORM, define an entity, and perform CRUD operations",
  "related": [
    "orm-configuration",
    "orm-entity-mapping",
    "orm-querying",
    "function-entitynew",
    "function-entitysave",
    "function-entityload",
    "function-entityloadbypk",
    "function-entitydelete",
    "function-ormflush"
  ]
}
-->

# ORM - Getting Started

Lucee's ORM (Object-Relational Mapping) lets you work with database records as CFC objects instead of writing SQL. Define a persistent component, map its properties to columns, and use built-in functions like [[function-entitysave]] and [[function-entityload]] to read and write data.

Under the hood, Lucee uses [Hibernate 5.6](https://hibernate.org/orm/), one of the most widely used Java ORM frameworks.

## Enable ORM

Add ORM settings to your `Application.cfc`:

```cfml
component {

	this.name = "my-orm-app";

	this.datasource = "myDatasource";

	this.ormEnabled = true;
	this.ormSettings = {
		dbcreate: "dropcreate",
		cfclocation: [ getDirectoryFromPath( getCurrentTemplatePath() ) ]
	};
}
```

That's three essential settings:

- **`ormEnabled`** — turns ORM on
- **`dbcreate`** — tells Hibernate how to manage your database schema. `"dropcreate"` drops and recreates tables on every application start — perfect for development, **never use in production**
- **`cfclocation`** — where to scan for persistent CFCs. Defaults to your application root if omitted

Your `datasource` can be any supported database — H2, MySQL, PostgreSQL, MSSQL, Oracle, etc. ORM uses whichever datasource is set as `this.datasource`.

For the full list of settings, see [[orm-configuration]].

## Define an Entity

An entity is a CFC with `persistent="true"`. Each property maps to a database column:

```cfml
// User.cfc
component persistent="true" table="users" accessors="true" {

	property name="id"    fieldtype="id" generator="native" ormtype="integer";
	property name="name"  ormtype="string" length="150";
	property name="email" ormtype="string" length="255";

}
```

- **`persistent="true"`** — marks this CFC as an ORM entity
- **`table`** — the database table name (defaults to the CFC name if omitted)
- **`accessors="true"`** — generates getter/setter methods for each property
- **`fieldtype="id"`** — marks the primary key
- **`generator="native"`** — lets the database generate IDs (auto-increment on MySQL, sequence on PostgreSQL)
- **`ormtype`** — the Hibernate data type for the column

For more on entity mapping, primary keys, and inheritance, see [[orm-entity-mapping]].

## Create

Use [[function-entitynew]] to create a new entity instance, then [[function-entitysave]] to persist it:

```cfml
user = entityNew( "User" );
user.setName( "Susi Sorglos" );
user.setEmail( "susi@example.com" );
entitySave( user );
```

You can also pass a struct of property values:

```cfml
user = entityNew( "User", { name: "Susi Sorglos", email: "susi@example.com" } );
entitySave( user );
```

> **Note:** [[function-entitysave]] doesn't immediately write to the database — it marks the entity for persistence. The actual SQL runs when the session is flushed: either at the end of the request (if `flushAtRequestEnd=true`, the default), inside a `cftransaction` commit, or when you call [[function-ormflush]] explicitly. See [[orm-session-and-transactions]] for details.

## Read

Load entities by primary key, by criteria, or by example:

```cfml
// By primary key
user = entityLoadByPK( "User", 1 );

// By criteria struct — returns an array
results = entityLoad( "User", { name: "Susi Sorglos" } );

// All entities of a type
allUsers = entityLoad( "User" );
```

[[function-entityloadbypk]] returns a single entity or `null` if not found. [[function-entityload]] with a filter struct always returns an array.

For HQL queries, pagination, and more advanced loading, see [[orm-querying]].

## Update

Just modify the entity's properties — Hibernate tracks changes automatically:

```cfml
user = entityLoadByPK( "User", 1 );
user.setEmail( "new-email@example.com" );
// No need to call entitySave() — Hibernate detects the change and flushes it
```

This is called **dirty checking**. Any loaded entity that's been modified will be persisted when the session flushes. This is powerful but can surprise you — if you modify an entity for display purposes without intending to save, the change still persists. See [[orm-troubleshooting]] for how to avoid this.

## Delete

```cfml
user = entityLoadByPK( "User", 1 );
if ( !isNull( user ) )
	entityDelete( user );
```

Like `entitySave()`, the actual DELETE runs on flush.

## Complete Example

Here's a full working example you can drop into a directory and run:

**Application.cfc:**

```cfml
component {

	this.name = "orm-quickstart-#hash( getCurrentTemplatePath() )#";

	this.datasource = {
		class: "org.h2.Driver",
		connectionString: "jdbc:h2:mem:quickstart;DB_CLOSE_DELAY=-1"
	};

	this.ormEnabled = true;
	this.ormSettings = {
		dbcreate: "dropcreate",
		cfclocation: [ getDirectoryFromPath( getCurrentTemplatePath() ) ]
	};
}
```

**Product.cfc:**

```cfml
component persistent="true" table="products" accessors="true" {

	property name="id"    fieldtype="id" generator="native" ormtype="integer";
	property name="name"  ormtype="string" length="200";
	property name="price" ormtype="big_decimal";

}
```

**index.cfm:**

```cfml
<cfscript>
	// Create
	product = entityNew( "Product", { name: "Widget", price: 9.99 } );
	entitySave( product );
	ormFlush();

	// Read
	loaded = entityLoadByPK( "Product", product.getId() );
	writeOutput( "Created: #loaded.getName()# — $#loaded.getPrice()#<br>" );

	// Update
	loaded.setPrice( 12.99 );
	ormFlush();
	writeOutput( "Updated price: $#loaded.getPrice()#<br>" );

	// Delete
	entityDelete( loaded );
	ormFlush();

	remaining = entityLoad( "Product" );
	writeOutput( "Products after delete: #arrayLen( remaining )#<br>" );
</cfscript>
```

## Using Transactions

For anything beyond toy examples, wrap your ORM operations in a transaction:

```cfml
transaction {
	product = entityNew( "Product", { name: "Gadget", price: 19.99 } );
	entitySave( product );
	// transaction commit flushes the session automatically
}
```

If something goes wrong inside the transaction block, everything rolls back. Without a transaction, a flush failure leaves your data in a partial state with no way to recover. See [[orm-session-and-transactions]] for the full story.

## What's Next?

- [[orm-configuration]] — all ormSettings, schema management, naming strategies
- [[orm-entity-mapping]] — property types, primary key strategies, inheritance
- [[orm-relationships]] — many-to-one, one-to-many, many-to-many
- [[orm-querying]] — HQL queries and entity loading options
- [[orm-troubleshooting]] — common pitfalls and error messages

> **ColdBox users:** If you're using the ColdBox framework, check out [cborm](https://coldbox-orm.ortusbooks.com/) which provides service layers, Active Record patterns, and criteria builders on top of native ORM.
