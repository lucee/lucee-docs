<!--
{
  "title": "Null Values in Structs and Arrays",
  "id": "null-structs-and-arrays",
  "description": "How Lucee treats null values when looping structs versus arrays, and the recommended loop patterns.",
  "keywords": [
    "null",
    "struct",
    "array",
    "loop",
    "for-in",
    "isNull",
    "NullValue",
    "sparse array",
    "Lucee"
  ],
  "categories": [
    "core",
    "iterator"
  ],
  "related": [
    "null_support",
    "tag-loop",
    "function-isnull",
    "function-nullvalue",
    "function-arrayisdefined",
    "loop-labels"
  ]
}
-->

# Null Values in Structs and Arrays

Structs and arrays both can hold null values, but **iteration visits them differently**. Knowing that difference avoids "variable does not exist" / "value is NULL" errors and makes copy or transform code simpler.

This applies to both [[tag-loop]] (`loop struct` / `loop array`) and script `for ( ... in ... )` loops — the null visit/skip rules are the same.

For partial vs full null support, [[function-isnull]], and [[function-structkeyexists]] behaviour, see [[null_support]].

## Structs: null values are visited

When a struct key is set to null, iteration still yields that key. The value is null, so you must guard before using it.

### `loop struct`

```cfscript
sct = {};
sct[ "one" ] = "one";
sct[ "two" ] = nullValue();
sct[ "three" ] = "three";

loop struct=sct index="k" item="v" {
	echo( k & ":" & ( v ?: "null" ) & ";" );
}
// Example output (order may vary for unordered structs):
// two:null;three:three;one:one;
```

### `for ( key in struct )`

Same visit behaviour — null values are not skipped:

```cfscript
sct = {};
sct[ "one" ] = "one";
sct[ "two" ] = nullValue();
sct[ "three" ] = "three";

for ( k in sct ) {
	v = sct[ k ];
	echo( k & ":" & ( isNull( v ) ? "null" : v ) & ";" );
}
// Example output (order may vary for unordered structs):
// two:null;three:three;one:one;
```

Direct bracket or member access to a null struct value can throw under partial null support ("the value from key [...] is NULL"). Prefer the loop `item` from `loop struct`, or check with [[function-isnull]] before reading:

```cfscript
if ( isNull( sct[ "two" ] ) ) {
	// safe: key present with null, or not present, depending on null support
}
```

## Arrays: null / undefined slots are skipped

For arrays, both `loop array` and `for ( item in array )` only visit **defined, non-null** indexes. Explicit nulls and sparse gaps are skipped — there is no need for an `isNull( v )` check inside the loop body for those missing slots.

### `loop array`

```cfscript
arr = [];
arr[ 1 ] = "one";
arr[ 2 ] = nullValue();
arr[ 3 ] = "three";

loop array=arr index="k" item="v" {
	echo( k & ":" & v & ";" );
}
// Output:
// 1:one;3:three;
```

### `for ( item in array )`

Same skip behaviour — null / undefined slots are not visited:

```cfscript
arr = [];
arr[ 1 ] = "one";
arr[ 2 ] = nullValue();
arr[ 3 ] = "three";

for ( v in arr ) {
	echo( v & ";" );
}
// Output:
// one;three;
```

Sparse arrays behave the same way: only existing indexes appear.

```cfscript
arr = [];
arr[ 1 ] = "one";
arr[ 3 ] = "three";

loop array=arr index="k" item="v" {
	echo( k & ":" & v & ";" );
}
// Output:
// 1:one;3:three;
```

Use [[function-arrayisdefined]] when you need to know whether a specific index exists.

## Best practice: prefer `loop` when you need the index

Null visit/skip rules are the same for `loop` and `for-in`. Prefer [[tag-loop]] with `index` and `item` when you need the key or array index (for example to rebuild a sparse array).

| Collection | Null behaviour | Typical guard |
|---|---|---|
| Struct (`loop struct` or `for-in`) | Null values **are** visited | `if ( isNull( v ) )` |
| Array (`loop array` or `for-in`) | Null / undefined slots **are skipped** | Usually none |

### Copy or transform pattern

Assign by the loop index/key so sparse array shapes stay intact. Handle null only for structs:

```cfscript
function copyCollection( required any input ) {
	if ( isStruct( arguments.input ) ) {
		var result = [:];
		loop struct=arguments.input index="k" item="v" {
			if ( isNull( v ) ) {
				result[ k ] = nullValue();
			}
			else {
				result[ k ] = v; // or recurse / transform
			}
		}
		return result;
	}

	if ( isArray( arguments.input ) ) {
		var result = [];
		loop array=arguments.input index="k" item="v" {
			// null / undefined slots are not visited
			result[ k ] = v; // or recurse / transform
		}
		return result;
	}

	return arguments.input;
}
```

## Summary

- **Struct nulls are visited** by both `loop struct` and `for-in` — check `isNull( v )` (or `v ?: default`) before use.
- **Array nulls and gaps are skipped** by both `loop array` and `for-in` — keep the loop body simple.
- Use `loop struct` / `loop array` with `index` and `item` when you need keys or indexes (for example `result[ k ] = ...` to preserve sparse arrays).
