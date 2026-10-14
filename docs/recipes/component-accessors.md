<!--
{
  "title": "Component Accessors",
  "id": "component-accessors",
  "since": "4.0",
  "categories": ["component", "best-practices", "performance"],
  "description": "CFML component accessors=true — what gets generated, how they behave with mixins and ORM, and the gotchas that bite",
  "keywords": [
    "accessors",
    "getter",
    "setter",
    "cfproperty",
    "property",
    "component",
    "bean",
    "fluent API",
    "mixin",
    "virtual inheritance",
    "ORM",
    "type coercion"
  ],
  "related": [
    "tag-component",
    "tag-property",
    "function-getmetadata",
    "inline-component",
    "structs-vs-components",
    "orm-entity-mapping",
    "orm-relationships"
  ]
}
-->

# Component Accessors

You've possibly written this CFC a hundred times:

```javascript
component {
    property name="firstName";
    property name="lastName";
    property name="email";

    function getFirstName() { return variables.firstName; }
    function setFirstName(value) { variables.firstName = arguments.value; return this; }
    function getLastName() { return variables.lastName; }
    function setLastName(value) { variables.lastName = arguments.value; return this; }
    function getEmail() { return variables.email; }
    function setEmail(value) { variables.email = arguments.value; return this; }
}
```

Add `accessors="true"` to the component tag and you get those getters and setters for free:

```javascript
component accessors="true" {
    property name="firstName";
    property name="lastName";
    property name="email";
}
```

Same six methods, generated for free. Persistent (ORM) components get them automatically — `accessors="true"` is implicit there.

## What you actually get

For each `<cfproperty name="x">` you get:

- `getX()` — returns `variables.x`
- `setX(value)` — writes to `variables.x` and returns the component (for chaining)

So you can do:

```javascript
user = new User()
    .setFirstName("Zac")
    .setLastName("Spitzer")
    .setEmail("zac@example.com");
```

### Relationship properties get extra helpers — but only with `fieldType`

If you declare an ORM relationship `fieldType` on a property, you also get collection helpers:

- `fieldType="one-to-many"` / `"many-to-many"` → `addX`, `hasX`, `removeX`
- `fieldType="one-to-one"` / `"many-to-one"` → `hasX` only (single-entity relationships, not collections)

```javascript
component accessors="true" {
    property name="tags" type="array" fieldType="one-to-many" cfc="Tag" singularName="tag";
}

post = new Post();
post.addTag("cfml");          // see orm-relationships for the full contract
```

**The gate is the `fieldType` attribute, not `type="array"` / `type="struct"`.** A bare `property name="tags" type="array"` with no `fieldType` has no `addTags`/`hasTags`/`removeTags` — only `getTags`/`setTags`. The [`orm-relationships`](orm-relationships.md) recipe covers the mapping side (cascade, fetching, `singularName`); the helper-method semantics are below.

### How `hasX` / `removeX` compare items

The argument type and comparison rule depend on the property's `type=`:

- **`type="array"`** — argument is the singular item (any type). Comparison uses the ORM-aware equals: entity identity for persistent components, value comparison otherwise. `removeX` walks the whole array and removes every match (in well-mapped ORM collections there's only ever one).
- **`type="struct"`** — argument is the struct `key` (string). Lucee structs are case-insensitive, so `hasTag("CFML")` matches a key stored as `"cfml"`. If Hibernate hands back a plain Java `Map` rather than a Lucee `Struct` (which it sometimes does for ORM-managed struct collections), the comparison is case-sensitive — `hasTag("CFML")` won't match `"cfml"`. If your code mixes casing, normalise the keys before adding.

For single-entity relationships (`one-to-one` / `many-to-one`), the no-arg form `hasX()` returns whether a related entity is loaded. The single-arg form `hasX(entity)` on those relationships always returns `false` — the comparison path only handles arrays/lists/structs.

## Setters check the type — they don't convert it

If you declare a type, the setter validates that the value *could* be cast to that type. It doesn't actually coerce — the value is stored as-is:

```javascript
component accessors="true" {
    property name="age" type="numeric";
}

u = new User();
u.setAge("42");      // "42" is castable to numeric → stored as the string "42"
u.setAge("nope");    // not castable to numeric → throws

writeOutput(u.getAge());          // "42"  (still a string)
writeOutput(u.getAge() + 1);      // 43    (CFML's loose typing coerces on arithmetic)
```

Same compatibility rules as `cfargument type="..."`. The type acts as a guard — bad data fails loudly at the setter — without forcing you into Java-style strict typing for the rest of your code. Drop the type (or use `type="any"`) if you want no check at all.

## Defaults seed the property

Set a `default` on the property and it's already there at construction:

```javascript
component accessors="true" {
    property name="status" default="pending";
    property name="active" type="boolean" default="true";
}

u = new User();
u.getStatus();   // "pending"
u.getActive();   // true
```

Worth knowing: `default` works regardless of `accessors="true"` — the value gets seeded into `variables` either way ([LDEV-929](https://luceeserver.atlassian.net/browse/LDEV-929)). The accessor just gives you a getter to read it back through.

## Storage lives in `variables`, not `this`

Property defaults seed `variables`, and accessors read/write `variables`. `this` is a separate (public) scope and isn't populated automatically:

```javascript
component accessors="true" {
    property name="message" default="hello";

    function show() {
        return "getMessage(): " & getMessage()
             & " | variables.message: " & variables.message
             & " | this.message: " & (this.message ?: "(undefined)");
    }
}
```

`getMessage()` and `variables.message` always agree — `setMessage("x")` writes `variables.message`, and a direct `variables.message = "y"` is what the next `getMessage()` reads. `this.message` only exists if you explicitly assign it.

If you want a property visible on `this`, mirror it yourself in `init()`:

```javascript
function init() {
    this.message = variables.message;
    return this;
}
```

Or set `this.invokeImplicitAccessor = true` (also accepted as `this.triggerDataMember`) in `Application.cfc`. That makes external `obj.message` access call `obj.getMessage()` implicitly. Most apps leave it off; framework code occasionally relies on it.

## The mixin trick — accessors rebind to their host

This is where it gets interesting, and where ColdBox/WireBox's virtual inheritance pattern comes from. You can grab an accessor from one CFC and inject it into another:

```javascript
foo = new Foo();   // accessors=true, has property name="message", "from-foo"
bar = new Bar();   // no property, but variables.message="from-bar"

bar.injectMixin = function(name, fn) {
    variables[name] = fn;
    this[name] = fn;
};

bar.injectMixin("getMessage", foo.getMessage);

bar.getMessage();   // → "from-bar"  ← reads BAR's scope, not foo's!
```

The accessor "rebinds" to whichever component it lives on. Once injected into `bar`, `getMessage()` reads `bar.variables.message`. This is the Lucee contract since 2018 ([LDEV-1962](https://luceeserver.atlassian.net/browse/LDEV-1962)).

There's a subtlety. **A ref held in a variable stays bound to its source CFC** — the rebind only kicks in when you assign the accessor onto another component:

```javascript
ref = foo.getMessage;
ref();              // → "from-foo"  ← no host, dispatches via foo

arrayMap([foo, bar], (cfc) => cfc.getMessage())
// → ["from-foo", "from-bar"]   each iteration extracts from the right cfc
```

That's what you want for higher-order calls: `users.map((u) => u.getName())` works exactly as you'd expect.

## Metadata says "owner is the source CFC"

If you ask for metadata on an injected accessor, Lucee reports the *original* CFC, not the host:

```javascript
listLast(getMetaData(bar.getMessage).owner, "/")   // → "Foo.cfc"
```

The dispatch contract is "host's scope wins"; the metadata contract is "source CFC owns the definition." Different questions, different answers — useful when frameworks need to trace a method back to its origin.

## Interfaces — implicit getters count

If your interface declares `getName()` and your component has `<cfproperty name="name">` with `accessors="true"`, the auto-generated getter satisfies the interface ([LDEV-1663](https://luceeserver.atlassian.net/browse/LDEV-1663)):

```javascript
interface IPerson {
    function getName();
}

component implements="IPerson" accessors="true" {
    property name="name";
    // no explicit getName() — the generated one satisfies IPerson
}
```

## Performance — cheap in the normal case

Accessors are cheap when you call them the obvious way. Method bodies are shared across all instances of the same CFC, and `obj.getName()` does a scope read rather than a full UDF dispatch. You don't need to worry about per-call overhead in app code.

The one path that costs more is **indirect invocation** — pulling the accessor into a variable first:

```javascript
var fn = obj.getName;
fn();                  // allocates a short-lived wrapper per call
```

Fine for occasional framework code, worth avoiding in tight loops.

For `persistent="true"` entities, Hibernate calls the generated setters during hydration — once per property per row. Across a query that's a lot of setter calls, so keep ORM setters mechanical and push validation, casting, or computed-value logic into post-load hooks.

## Gotchas

### Body-defined `getX()`/`setX()` overrides the auto-generated one

If you write a getter or setter for a property in the component body, it overrides the auto-generated version — body UDFs hoist last. That's the builder pattern:

```javascript
component accessors="true" {
    property name="message";

    function getMessage() {     // overrides the auto-generated getter
        return "explicit: " & variables.message;
    }
}
```

Use this when you need custom logic on one or two properties without giving up the generated accessors for the rest. Reach for `variables.message` inside the override if you want to read the raw stored value — calling `getMessage()` from inside `getMessage()` is infinite recursion.

### Getters return references, not copies

For complex types, the getter hands back the live reference:

```javascript
component accessors="true" {
    property name="data" type="struct";
    
    function init() {
        variables.data = { count: 1 };
        return this;
    }
}

obj = new MyCFC();
ref = obj.getData();
ref.count = 99;          // mutates the shared struct
obj.getData().count;     // → 99
```

If you need isolation, return `duplicate(variables.data)` from a custom getter, or document the sharing contract.

### Setter call overhead during init

When constructing an object with many properties, every `setX()` call runs the type-castability check and dispatches the setter. If you trust your input data, direct scope writes skip both:

```javascript
function init(args) {
    structAppend(variables, arguments, true);   // bypasses setters
    return this;
}
```

Don't do this if you depend on the type check or any custom setter logic. It's a tradeoff.

## When to skip accessors

Accessors shine for value objects, ORM entities, and DTOs — anything that's mostly data with a thin API. They're overhead when:

- The component is service-style (no state, just methods)
- A property is read-only (set once at init, never again)
- The getter or setter needs non-trivial logic — write the methods explicitly

For service components, drop `accessors="true"` and write only the methods you actually need. Less generated code, less to surprise you later.
