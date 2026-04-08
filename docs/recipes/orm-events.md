<!--
{
  "title": "ORM - Events",
  "id": "orm-events",
  "categories": [
    "orm"
  ],
  "description": "Entity lifecycle events, global event handlers, event firing order, and patterns for setting values in preInsert/preUpdate handlers in Lucee ORM",
  "related": [
    "orm-session-and-transactions",
    "orm-entity-mapping",
    "orm-configuration",
    "orm-troubleshooting"
  ]
}
-->

# ORM - Events

Hibernate fires events at key points in an entity's lifecycle — before insert, after load, on flush, etc. You can hook into these events to implement audit logging, auto-set timestamps, enforce business rules, or sync data.

## Enabling Events

Entity-level events (methods defined directly in entity CFCs) fire automatically — no configuration needed.

The **global event handler** requires `eventHandling: true` in your [[orm-configuration]]:

```cfml
this.ormSettings = {
	eventHandling: true,
	eventHandler: "models.GlobalEventHandler"
};
```

Without `eventHandling: true`, the global handler CFC is not registered. Entity-level events are unaffected.

## Entity Events

Define event methods directly in your entity CFC. These fire only for that entity:

```cfml
component persistent="true" table="users" accessors="true" {

	property name="id"          fieldtype="id" ormtype="string";
	property name="name"        ormtype="string";
	property name="username"    ormtype="string" notnull="true";
	property name="password"    ormtype="string" notnull="true";
	property name="dateCreated" ormtype="timestamp";
	property name="dateUpdated" ormtype="timestamp";

	function preInsert() {
		setDateCreated( now() );
		if ( isNull( getPassword() ) )
			setPassword( createUUID() );
	}

	function preUpdate() {
		setDateUpdated( now() );
	}

}
```

### Available Entity Events

| Event | Fires When | Arguments |
|-------|------------|-----------|
| `preInsert()` | Before INSERT SQL executes | none |
| `postInsert()` | After INSERT SQL executes | none |
| `preUpdate()` | Before UPDATE SQL executes | none |
| `postUpdate()` | After UPDATE SQL executes | none |
| `preDelete()` | Before DELETE SQL executes | none |
| `postDelete()` | After DELETE SQL executes | none |
| `preLoad()` | Before entity is populated from DB | none |
| `postLoad()` | After entity is populated from DB | none |

## Global Event Handler

A global event handler receives events for ALL entities. Set it in your ormSettings:

```cfml
this.ormSettings = {
	eventHandling: true,
	eventHandler: "models.GlobalEventHandler"
};
```

The handler CFC should NOT be persistent:

```cfml
// models/GlobalEventHandler.cfc
component persistent="false" {

	function preInsert( entity ) {
		// runs for every entity insert
	}

	function postInsert( entity ) {
	}

	function preUpdate( entity, struct oldData ) {
		// oldData contains the previous values
	}

	function postUpdate( entity ) {
	}

	function preDelete( entity ) {
	}

	function onDelete( entity ) {
	}

	function postDelete( entity ) {
	}

	function preLoad( entity ) {
	}

	function postLoad( entity ) {
	}

	function onFlush( entity ) {
	}

	function onClear( entity ) {
	}

	function onEvict() {
	}

	function onAutoFlush() {
	}

	function onDirtyCheck() {
	}

}
```

### All Global Events

| Event | Fires When | Arguments |
|-------|------------|-----------|
| `preInsert( entity )` | Before INSERT | The entity being inserted |
| `postInsert( entity )` | After INSERT | The entity that was inserted |
| `preUpdate( entity, oldData )` | Before UPDATE | The entity and a struct of previous values |
| `postUpdate( entity )` | After UPDATE | The entity that was updated |
| `preDelete( entity )` | Before DELETE | The entity being deleted |
| `onDelete( entity )` | During DELETE processing | The entity being deleted |
| `postDelete( entity )` | After DELETE | The entity that was deleted |
| `preLoad( entity )` | Before population from DB | The empty entity |
| `postLoad( entity )` | After population from DB | The loaded entity |
| `onFlush( entity )` | When session flush begins | The entity being flushed |
| `onClear( entity )` | When session is cleared | — |
| `onEvict()` | When an entity is evicted from the session | — |
| `onAutoFlush()` | When an auto-flush is triggered | — |
| `onDirtyCheck()` | When Hibernate checks for dirty entities | — |

## Event Firing Order

When both entity-level and global event handlers define the same event, the **entity event fires first**, then the global handler. *(Changed in 5.6 — previously the global handler fired first, LDEV-4561)*

For an insert with both handlers:

1. Entity `preInsert()`
2. Global `preInsert( entity )`
3. INSERT SQL executes
4. Entity `postInsert()`
5. Global `postInsert( entity )`

## Events Fire on Flush, Not on Save

This is a critical distinction. Calling `entitySave()` does NOT trigger `preInsert` — the event fires when the session flushes:

```cfml
entity = entityNew( "Auto", { id: createUUID(), make: "BMW" } );
entitySave( entity );
// preInsert has NOT fired yet

ormFlush();
// NOW preInsert fires, then INSERT executes, then postInsert fires
```

This means:

- Inside a transaction, events fire when the transaction commits (which triggers a flush)
- With `flushAtRequestEnd: true`, events fire at the end of the request
- With explicit `ormFlush()`, events fire immediately

## Setting Values in preInsert / preUpdate

A common pattern: auto-set timestamps, generate default values, or enforce constraints in `preInsert` or `preUpdate`. Hibernate syncs changes made in these handlers back to the database state automatically:

```cfml
function preInsert() {
	setDateCreated( now() );
	if ( isNull( getPassword() ) )
		setPassword( createUUID() );
}
```

This works because the extension's `EventListenerIntegrator` calls `persistEntityChangesToState()` after your handler runs — syncing CFC property mutations back to the Hibernate state array that gets persisted.

> **This is a 5.6 improvement.** In earlier versions, setting a NOT NULL property in `preInsert` could throw a constraint violation because Hibernate's nullability check ran before the handler had a chance to set the value. In 5.6, the nullability check runs AFTER event handlers.

## Practical Patterns

### Audit Logging

```cfml
// GlobalEventHandler.cfc
component persistent="false" {

	function preInsert( entity ) {
		logEvent( "INSERT", entity );
	}

	function preUpdate( entity, struct oldData ) {
		logEvent( "UPDATE", entity );
	}

	function preDelete( entity ) {
		logEvent( "DELETE", entity );
	}

	private function logEvent( action, entity ) {
		cflog(
			text: "#action# #getMetadata( entity ).getName()#",
			log: "orm"
		);
	}

}
```

### Auto-Timestamps

```cfml
component persistent="true" table="articles" accessors="true" {

	property name="id"          fieldtype="id" ormtype="string";
	property name="title"       ormtype="string";
	property name="createdAt"   ormtype="timestamp";
	property name="updatedAt"   ormtype="timestamp";

	function preInsert() {
		setCreatedAt( now() );
		setUpdatedAt( now() );
	}

	function preUpdate() {
		setUpdatedAt( now() );
	}

}
```

### Conditional Logic in Global Handler

Use `getMetadata()` to branch on entity type:

```cfml
function preInsert( entity ) {
	var entityName = getMetadata( entity ).getName();
	if ( entityName == "User" ) {
		// user-specific logic
	}
}
```

## Common Mistakes

### Don't Call ORMFlush() in Event Handlers

Calling `ormFlush()` inside `preInsert`, `preUpdate`, or any event handler triggers another flush, which fires more events, which call `ormFlush()` again — infinite loop:

```cfml
// BAD — infinite loop
function preInsert() {
	setCreatedAt( now() );
	ormFlush();  // DON'T DO THIS
}
```

Just set values and return. The flush that triggered the event will persist your changes.

### Don't Call entitySave() in Event Handlers

Similarly, calling `entitySave()` on a different entity inside an event handler can cause unexpected cascading flushes. If you need to create related entities, do it outside the event handler.

### Events Don't Fire for Bulk DML

HQL `UPDATE` and `DELETE` statements bypass the entity lifecycle entirely — no events fire:

```cfml
// This does NOT trigger preDelete on any entity
ORMExecuteQuery( "DELETE FROM Product WHERE active = false" );
```

If you need events to fire, load and delete entities individually.

## What's Next?

- [[orm-session-and-transactions]] — how flush timing affects when events fire
- [[orm-configuration]] — `eventHandling` and `eventHandler` settings
- [[orm-troubleshooting]] — StackOverflowError from ormFlush() in handlers
