<!--
{
  "title": "ORM - Relationships",
  "id": "orm-relationships",
  "categories": [
    "orm"
  ],
  "description": "Mapping relationships between ORM entities: many-to-one, one-to-many, one-to-one, many-to-many, collections, cascade, fetching strategies, and batch loading",
  "related": [
    "orm-entity-mapping",
    "orm-querying",
    "orm-session-and-transactions",
    "orm-troubleshooting",
    "function-entitysave",
    "function-entityload"
  ]
}
-->

# ORM - Relationships

Relationships map associations between entities — a dealership has many cars, a student enrols in many courses, an order belongs to a customer. This page covers all relationship types, bidirectional mappings, cascade behaviour, fetching strategies, and batch loading.

## many-to-one

The most common relationship. The child entity holds a foreign key pointing to the parent:

```cfml
// Auto.cfc — the "many" side, holds the FK
component persistent="true" accessors="true" {

	property name="id"    fieldtype="id" ormtype="string";
	property name="make"  ormtype="string";
	property name="model" ormtype="string";
	property name="dealer"
		fieldtype="many-to-one"
		cfc="Dealership"
		fkcolumn="dealerID";

}
```

- **`cfc`** — the target entity name
- **`fkcolumn`** — the foreign key column in *this* entity's table

Loading a car automatically gives you access to the dealership via `car.getDealer()`.

### many-to-one Attributes

| Attribute | Description |
|-----------|-------------|
| `cfc` | Target entity name (required) |
| `fkcolumn` | Foreign key column name |
| `lazy` | `true` (default) — creates a proxy, loads on first access. `false` or `"no-proxy"` for immediate loading |
| `fetch` | `"select"` (default) or `"join"` |
| `notnull` | `true` to enforce NOT NULL on the FK column |
| `insert` | `false` to exclude FK from INSERT statements |
| `update` | `false` to exclude FK from UPDATE statements |
| `unique` | `true` to add a UNIQUE constraint (effectively makes it one-to-one) |
| `uniquekey` | Name of a multi-column unique constraint |
| `index` | Creates a database index on the FK column |
| `missingRowIgnored` | `true` to return null for orphaned FKs instead of throwing |

Example with constrained FK:

```cfml
property name="category"
	fieldtype="many-to-one"
	cfc="Category"
	fkcolumn="categoryId"
	notnull="true"
	insert="true"
	update="false";
```

This makes the category required and immutable after insert.

## one-to-many

The parent side of a many-to-one relationship. Returns a collection (array or struct) of child entities:

```cfml
// Dealership.cfc — the "one" side
component persistent="true" accessors="true" {

	property name="id"      fieldtype="id" ormtype="string";
	property name="name"    ormtype="string";
	property name="address" ormtype="string";
	property name="inventory"
		fieldtype="one-to-many"
		cfc="Auto"
		fkcolumn="dealerID"
		type="array"
		cascade="all-delete-orphan"
		inverse="true";

}
```

- **`type`** — `"array"` (ordered) or `"struct"` (keyed by a column)
- **`cascade`** — what operations cascade to children. See [Cascade Options](#cascade-options)
- **`inverse`** — `true` means the *other* side (many-to-one) owns the relationship. See [Bidirectional Relationships and inverse](#bidirectional-relationships-and-inverse)

### one-to-many Attributes

| Attribute | Description |
|-----------|-------------|
| `cfc` | Target entity name (required) |
| `fkcolumn` | Foreign key column in the *child* table |
| `type` | `"array"` or `"struct"` |
| `cascade` | Cascade behaviour. See [Cascade Options](#cascade-options) |
| `inverse` | `true` if the other side owns the FK |
| `lazy` | `true` (default), `false`, or `"extra"` |
| `fetch` | `"select"` (default) or `"join"` |
| `batchsize` | Batch-load uninitialised collections. See [Batch Fetching](#batch-fetching) |
| `orderby` | SQL ORDER BY clause for the collection, e.g. `"track_pos ASC"` |
| `where` | SQL WHERE filter applied to the collection, e.g. `"is_active = true"` |
| `readonly` | `true` to make the collection read-only |
| `singularName` | Generates `addX()`, `removeX()`, `hasX()` methods. See [singularName](#singularname) |
| `structKeyColumn` | Column to use as the struct key (when `type="struct"`) |

### Filtered Collections

Use the `where` attribute to filter which children are loaded:

```cfml
// Department.cfc — only loads active staff
component persistent="true" table="departments" accessors="true" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";
	property name="activeStaff"
		fieldtype="one-to-many"
		cfc="Staff"
		fkcolumn="deptId"
		type="array"
		where="is_active = true";

}
```

### Ordered Collections

Use `orderby` to sort children automatically:

```cfml
property name="tracks"
	fieldtype="one-to-many"
	cfc="Track"
	fkcolumn="playlistId"
	type="array"
	orderby="track_pos ASC";
```

## one-to-one

Links two entities that share a one-to-one relationship. Two approaches:

### Shared Primary Key

Both entities share the same primary key value:

```cfml
// Passport.cfc
component persistent="true" accessors="true" {

	property name="id"     fieldtype="id" ormtype="string";
	property name="number" ormtype="string";
	property name="holder"
		fieldtype="one-to-one"
		cfc="Citizen"
		lazy="false";

}
```

> **Tip:** `lazy="false"` is recommended for one-to-one relationships because Hibernate can't proxy them reliably — it doesn't know whether the other side exists without hitting the database.

### Unique Foreign Key

One side holds a FK column, creating a one-to-one via a unique foreign key constraint. Use `mappedby` on the non-FK side:

```cfml
// Employee.cfc — holds the FK
component persistent="true" table="employees" accessors="true" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";
	property name="office"
		fieldtype="one-to-one"
		cfc="Office"
		fkcolumn="officeId";

}
```

```cfml
// Office.cfc — uses mappedby to point to the FK side
component persistent="true" table="offices" accessors="true" {

	property name="id"       fieldtype="id" ormtype="string";
	property name="location" ormtype="string";
	property name="employee"
		fieldtype="one-to-one"
		cfc="Employee"
		mappedby="office";

}
```

> **Important:** `mappedby` in CFML ORM is NOT the same as JPA's `@MappedBy`. In CFML, `mappedby` means "the FK references a unique column other than the PK in the target entity". It's used for one-to-one unique FK associations and many-to-one referencing non-PK unique columns. For standard bidirectional many-to-one/one-to-many relationships, use `fkcolumn` + `inverse="true"` instead.

## many-to-many

Two entities linked through a join table:

```cfml
// Student.cfc — the owning side
component persistent="true" accessors="true" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";
	property name="courses"
		fieldtype="many-to-many"
		cfc="Course"
		linktable="student_course"
		fkcolumn="studentID"
		inversejoincolumn="courseID"
		type="array"
		lazy="true";

}
```

```cfml
// Course.cfc — the inverse side
component persistent="true" accessors="true" {

	property name="id"    fieldtype="id" ormtype="string";
	property name="title" ormtype="string";
	property name="students"
		fieldtype="many-to-many"
		cfc="Student"
		linktable="student_course"
		fkcolumn="courseID"
		inversejoincolumn="studentID"
		type="array"
		lazy="true"
		inverse="true";

}
```

- **`linktable`** — the join table name
- **`fkcolumn`** — the FK column in the join table pointing to *this* entity
- **`inversejoincolumn`** — the FK column in the join table pointing to the *other* entity
- **`inverse="true"`** — on the non-owning side (only one side should manage the join table rows)

### many-to-many Attributes

| Attribute | Description |
|-----------|-------------|
| `cfc` | Target entity name (required) |
| `linktable` | Join table name (required) |
| `fkcolumn` | FK in join table pointing to this entity |
| `inversejoincolumn` | FK in join table pointing to the target entity |
| `type` | `"array"` or `"struct"` |
| `inverse` | `true` on the non-owning side |
| `lazy` | `true` (default), `false`, or `"extra"` |
| `cascade` | Cascade behaviour |
| `orderby` | SQL ORDER BY for the collection |
| `where` | SQL WHERE filter on the collection |
| `linkschema` | Schema for the join table (if different from the entity schema) |
| `linkcatalog` | Catalog for the join table |
| `readonly` | `true` for a read-only collection |

## Element Collections

For simple value collections (arrays of strings, maps of key-value pairs) that don't map to another entity, use `fieldtype="collection"`:

### Array Collection (Bag)

```cfml
component persistent="true" accessors="true" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";
	property name="tags"
		fieldtype="collection"
		type="array"
		table="item_tags"
		fkcolumn="parentId"
		elementcolumn="tag"
		elementtype="string";

}
```

### Map Collection (Struct)

```cfml
component persistent="true" accessors="true" {

	property name="id"   fieldtype="id" ormtype="string";
	property name="name" ormtype="string";
	property name="metadata"
		fieldtype="collection"
		type="struct"
		table="item_metadata"
		fkcolumn="parentId"
		structKeyColumn="metaKey"
		structKeyType="string"
		elementcolumn="metaValue"
		elementtype="string";

}
```

- **`table`** — the collection table
- **`fkcolumn`** — FK back to the parent entity
- **`elementcolumn`** — column holding the values
- **`elementtype`** — data type of the values
- **`structKeyColumn`** / **`structKeyType`** — for struct collections, the column and type used as the key

## Bidirectional Relationships and inverse

Most real-world relationships are bidirectional — you want to navigate from parent to children *and* from child to parent. The critical question is: **which side owns the relationship?**

### The Problem Without inverse

If both sides try to manage the foreign key, you get duplicate SQL:

```sql
-- Hibernate inserts the child
INSERT INTO autos (id, make, model, dealerID) VALUES (?, ?, ?, ?)
-- Then the parent ALSO updates the FK column (redundant!)
UPDATE autos SET dealerID = ? WHERE id = ?
```

### The Fix: inverse="true"

Set `inverse="true"` on the **non-owning** side (the one-to-many or the many-to-many inverse side). This tells Hibernate: "the other side manages the FK — don't generate SQL for this side."

```cfml
// Dealership.cfc — inverse=true means Auto owns the FK
property name="inventory"
	fieldtype="one-to-many"
	cfc="Auto"
	fkcolumn="dealerID"
	type="array"
	cascade="all-delete-orphan"
	inverse="true";
```

**Rules of thumb:**

- **many-to-one / one-to-many** — the many-to-one side always owns the FK. Set `inverse="true"` on the one-to-many side
- **many-to-many** — pick one side as the owner. Set `inverse="true"` on the other
- **one-to-one** — the side with the `fkcolumn` owns the relationship

## Cascade Options

The `cascade` attribute controls which operations propagate from parent to child:

| Value | Behaviour |
|-------|-----------|
| `"none"` | No cascading (default). You must save/delete children explicitly |
| `"save-update"` | `entitySave()` on the parent also saves new/modified children |
| `"delete"` | `entityDelete()` on the parent also deletes children |
| `"all"` | Combines save-update + delete |
| `"all-delete-orphan"` | Like `"all"`, plus deletes children that are removed from the collection |
| `"refresh"` | `entityReload()` on the parent also reloads children |

### When to Use Each

- **`"all-delete-orphan"`** — parent fully owns the children (e.g. an order owns its line items). Removing a line item from the order deletes it from the database
- **`"all"`** — parent manages children but children can exist independently (e.g. a dealership and its inventory)
- **`"save-update"`** — you want to save new children by adding them to the parent, but deleting the parent shouldn't delete children
- **`"none"`** — children are independently managed. You must call `entitySave()` and `entityDelete()` on each child explicitly

> **Warning:** `"all-delete-orphan"` means that removing a child from the collection deletes it from the database. If you accidentally clear the collection, all children are deleted.

## Fetching Strategies

Fetching controls *when* and *how* related entities are loaded from the database.

### Lazy Loading (Default)

Collections (`one-to-many`, `many-to-many`) default to `lazy="true"` — they load on first access:

```cfml
dealer = entityLoadByPK( "Dealership", "abc" );
// No SQL for inventory yet
cars = dealer.getInventory();
// NOW the SQL runs: SELECT * FROM autos WHERE dealerID = ?
```

### Eager Fetching with JOIN

Use `fetch="join"` when you always need the association — loads it in a single JOIN query:

```cfml
property name="articles"
	fieldtype="one-to-many"
	cfc="Article"
	fkcolumn="authorId"
	type="array"
	fetch="join";
```

Good for small, always-needed collections. Bad for large collections or entities where you sometimes don't need the association.

### Extra Lazy

`lazy="extra"` is a middle ground for large collections. Calling `.size()` or checking `.isEmpty()` runs a COUNT query instead of loading the full collection. Individual items load on access:

```cfml
property name="members"
	fieldtype="one-to-many"
	cfc="Member"
	fkcolumn="groupId"
	type="array"
	lazy="extra";
```

### Proxy Lazy (many-to-one / one-to-one)

many-to-one relationships default to `lazy="true"`, which creates a proxy object. The real entity loads on the first method call (other than `getId()`):

```cfml
article = entityLoadByPK( "Article", "123" );
// article.getAuthor() returns a proxy — no SQL yet
// article.getAuthor().getName() triggers the SELECT
```

Set `lazy="false"` to load immediately, or `lazy="no-proxy"` for immediate load without proxy wrapping.

### The N+1 Problem

Loading a list of parents and then iterating to access a lazy relationship triggers one query per parent:

```cfml
// 1 query: SELECT * FROM dealerships
dealers = entityLoad( "Dealership" );
for ( dealer in dealers ) {
	// N queries: SELECT * FROM autos WHERE dealerID = ? (once per dealer!)
	writeOutput( arrayLen( dealer.getInventory() ) );
}
```

**Fixes:**

- **Batch fetching** — `batchsize` on the relationship. See [Batch Fetching](#batch-fetching)
- **HQL JOIN FETCH** — `ORMExecuteQuery( "FROM Dealership d JOIN FETCH d.inventory" )`. See [[orm-querying]]
- **Eager fetch** — `fetch="join"` if you always need the association
- **Diagnosis** — enable `logSQL: true` in [[orm-configuration]]. If you see the same SELECT repeated with different IDs, you've got N+1

## Batch Fetching

Batch fetching is the most practical N+1 fix. Instead of loading one collection at a time, Hibernate loads multiple uninitialised collections in a single query.

### On Relationships

```cfml
property name="books"
	fieldtype="one-to-many"
	cfc="Book"
	fkcolumn="publisherId"
	type="array"
	lazy="true"
	batchsize="10";
```

If you load 25 publishers and access the first one's books, Hibernate loads books for 10 publishers in one query. That's 3 queries (10 + 10 + 5) instead of 25.

### On Entities

Set `batchsize` on the component to batch-load proxied entity instances:

```cfml
component persistent="true" accessors="true" batchsize="5" {
	// ...
}
```

When Hibernate needs to resolve a proxy for this entity type, it loads up to 5 at once.

## singularName

The `singularName` attribute generates convenience methods for collection management:

```cfml
// Library.cfc
property name="books"
	singularName="book"
	fieldtype="one-to-many"
	cfc="LibBook"
	fkcolumn="libraryId"
	type="array"
	cascade="all";
```

This generates:

- `addBook( book )` — adds a book to the collection
- `removeBook( book )` — removes a book from the collection
- `hasBook( book )` — checks if a book is in the collection

```cfml
library = entityLoadByPK( "Library", "abc" );
book = entityNew( "LibBook", { id: createUUID(), title: "CFML in Action" } );
library.addBook( book );
entitySave( library );
```

## missingRowIgnored

When a foreign key points to a row that no longer exists in the target table (orphaned FK), Hibernate normally throws an exception. Set `missingRowIgnored="true"` to return null instead:

```cfml
property name="parent"
	fieldtype="many-to-one"
	cfc="Parent"
	fkcolumn="parentId"
	missingRowIgnored="true";
```

Applies to many-to-one, one-to-one, and many-to-many.

## Common Mistakes

### Collection Replacement Trap

Don't replace a collection — modify it in place:

```cfml
// BAD — Hibernate loses track of the proxied collection
entity.setChildren( newArray );

// GOOD — modify the existing collection
entity.getChildren().clear();
entity.getChildren().addAll( newArray );
```

When you replace the collection object, Hibernate can't track what changed and recreates the entire thing (DELETE all + INSERT all).

### Missing inverse

Without `inverse="true"` on the one-to-many side of a bidirectional relationship, every save generates redundant UPDATE statements. Your data is correct but you're doing twice the SQL.

### Cascade Without inverse

If you set `cascade="all-delete-orphan"` on a one-to-many but forget `inverse="true"`, Hibernate tries to null out the FK column before deleting the child row — which fails if the FK has a NOT NULL constraint.

## What's Next?

- [[orm-querying]] — HQL with JOIN FETCH to solve N+1 at query time
- [[orm-session-and-transactions]] — how flush timing affects relationship persistence
- [[orm-troubleshooting]] — "unsaved transient instance", "collection was not an association", and other relationship errors
