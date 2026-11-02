<!--
{
  "title": "Component onMissingProperty",
  "id": "component-onmissingproperty",
  "since": "9.0",
  "categories": ["component"],
  "description": "Define onMissingProperty( name ) in a component to handle reads of keys that don't exist, like onMissingMethod does for function calls.",
  "keywords": [
    "onMissingProperty",
    "onMissingMethod",
    "missing key",
    "dynamic",
    "proxy",
    "component",
    "this scope"
  ],
  "related": [
    "tag-component",
    "component-accessors",
    "structs-vs-components",
    "function-structkeyexists",
    "function-isdefined"
  ]
}
-->

# Component onMissingProperty

Since Lucee 9.0 a component can define an optional function `onMissingProperty( name )`. It is called when code outside of the component reads a key that doesn't exist on the component, and its return value becomes the value of the read. It is the counterpart of `onMissingMethod`, which handles calls to functions that don't exist.

```javascript
// Settings.cfc
component {

	variables.data = { host: "localhost", port: 8080 };

	function onMissingProperty( required string name ) {
		if ( structKeyExists( variables.data, arguments.name ) ) return variables.data[ arguments.name ];
		throw( type="application", message="Unknown setting [#arguments.name#]" );
	}

}
```

```javascript
settings = new Settings();
echo( settings.host ); // localhost
echo( settings[ "port" ] ); // 8080
```

## What triggers it

`onMissingProperty` is called for reads that would otherwise throw `Component [x] has no accessible Member with name [y]`:

- `obj.foo`
- `obj[ "foo" ]` and `obj[ name ]`

The function receives the name of the key as written in the code (`obj.foo` passes `foo`, `obj[ "Foo" ]` passes `Foo`) and can return any value, including nothing (the read is then `null`).

The function is only looked up when a key is missing, so a component that doesn't define it has no extra cost, and a key that exists is returned without calling it.

## What does not trigger it

- **Existence checks.** `structKeyExists( obj, "foo" )`, `isDefined( "obj.foo" )`, `isNull( obj.foo )` and the elvis operator (`obj.foo ?: "default"`) don't call `onMissingProperty` and still report that the key doesn't exist. The function only applies to reads that expect a value. If you want those checks to be true for your dynamic keys, define the keys in the component instead.
- **Reads inside the component.** A read from code of the component itself, for example `variables.foo` or `this.foo` in one of its functions, is not handled. The same is true for code in a parent or child component of the same instance. A missing key there is an error as it always was.
- **Writes.** There is no setter variant. `obj.foo = "bar"` behaves as before.
- **Function calls.** `obj.foo()` still goes to `onMissingMethod`. A component can define both functions.

If the component doesn't define `onMissingProperty` (or it is not accessible, see below), reading a missing key throws the same error as in earlier versions.

## Inheritance and access

A component inherits `onMissingProperty` from its parent component and can override it, like any other function. Like `onMissingMethod` it needs to be accessible from the code that reads the key, so define it as a `public` function (a `private` one is ignored).

## Accessors

Existing members and accessors win over `onMissingProperty`:

1. a key that exists (`this.foo`) is returned,
2. with implicit accessors enabled (`this.invokeImplicitAccessor = true` in `Application.cfc`, see [[component-accessors]]) a matching getter like `getFoo()` is called,
3. otherwise `onMissingProperty( "foo" )` is called, if it exists.

## Reading a missing key inside onMissingProperty

Reading a missing key of the same component from inside `onMissingProperty` (for example `this.other` or `variables.me.other` where `me` is the component itself) is a read from inside the component, so it doesn't call `onMissingProperty` again. It throws the normal error, there is no endless loop.

Reading a missing key of a different component that has its own `onMissingProperty` calls that function. If two components read each other's missing keys, they can of course call each other forever, this is up to your code.
