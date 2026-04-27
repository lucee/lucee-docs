<!--
{
  "title": "Diagnosing pre-7.1 struct ordering regressions with `lucee.concurrent.map.impl=legacy`",
  "id": "concurrent-map-legacy-flag",
  "categories": ["struct", "compat", "debugging"],
  "menuTitle": "Legacy struct-ordering flag",
  "description": "The `lucee.concurrent.map.impl=legacy` flag restores pre-7.1 struct iteration order, used as a diagnostic to confirm whether a 7.1 regression is an ordering-assumption bug in your code.",
  "keywords": [
    "ConcurrentHashMap",
    "struct",
    "lucee.concurrent.map.impl",
    "legacy",
    "struct ordering",
    "LDEV-5098",
    "LDEV-6288"
  ],
  "related": [
    "breaking-changes-7-0-to-7-1",
    "function-structnew",
    "function-objectsave",
    "function-objectload",
    "function-serialize",
    "troubleshooting"
  ],
  "since": "7.1.0.105"
}
-->

# Diagnosing pre-7.1 struct ordering regressions with `lucee.concurrent.map.impl=legacy`

Lucee 7.1 ([LDEV-5098](https://luceeserver.atlassian.net/browse/LDEV-5098)) replaced the pre-7.1 segmented `ConcurrentHashMap` backing default-flavour structs with a thin wrapper over the JDK's own `java.util.concurrent.ConcurrentHashMap`. The new map is faster and gets ongoing JDK improvements for free, but it iterates keys in a **different order** than the old custom implementation.

The new order is itself implementation-defined — it depends on the JDK's bucket layout and may shift across JDK versions or vendor builds, so don't treat the 7.1 order as a stable target either. The fix is to stop assuming any iteration order in your code.

CFML structs have never guaranteed iteration order — `StructNew("ordered")` is the supported way to get a stable ordering — but plenty of real-world code drifted into assuming the old order was stable. When 7.1 shipped, that code broke quietly:

```cfml
var s = { "data": {}, "includes": ["a.js"], "adhoc": {} };
serializeJSON( s )
// 7.0: {"data":{},"includes":["a.js"],"adhoc":{}}
// 7.1: {"includes":["a.js"],"adhoc":{},"data":{}}
```

JSON-string comparisons in tests, hash digests built from `serializeJSON`, comma-lists composed from struct keys — all technically wrong but working on 7.0, and silently broken on 7.1.

[LDEV-6288](https://luceeserver.atlassian.net/browse/LDEV-6288) introduces **`lucee.concurrent.map.impl=legacy`** as a diagnostic flag. Set it, restart, and Lucee uses the pre-7.1 segmented map for default-flavour structs — restoring the old iteration order exactly. Use it to confirm whether a 7.1 regression in your code is genuinely an ordering-assumption bug, then fix the code and drop the flag.

## The workflow

You upgraded to 7.1 and something broke — a serialised JSON string doesn't match, a test fails on a comma-list comparison, a cached fragment stopped matching.

1. **Set the flag in your JVM args:**

   ```bash
   -Dlucee.concurrent.map.impl=legacy
   ```

   Or as an environment variable (Lucee normalises dots to underscores and uppercases):

   ```bash
   LUCEE_CONCURRENT_MAP_IMPL=legacy
   ```

   Set it in `setenv.sh` / `setenv.bat` for Tomcat, `CATALINA_OPTS`, your Docker `ENV`, or however you configure JVM args for your deployment.

2. **Restart Lucee.**

3. **Re-run the broken thing.**

   - **Breakage goes away?** Confirmed — your code was relying on unordered struct iteration order. Fix the code (use `StructNew("ordered")`, sort keys before comparing, compare parsed structs instead of JSON strings), then **drop the flag** and run on the modern JDK-backed default. That's the destination — `legacy` was there to prove the diagnosis.
   - **Breakage persists?** It's not an ordering issue. Keep investigating without the flag. One common non-fix: tests that hardcode literal hash output like `fk_04256baa79b5ed9099b1dde0da7eb613` from `hash(serializeJSON(someStruct))` (this example is from Preside; the `fk_` prefix is Preside's foreign-key cache key convention). Those are cross-version fragile by design and `legacy` can't restore an exact hash value from an old Lucee+JDK combo — only a source fix (sort keys first, or hash deterministic content instead of the struct) resolves them.

Treat `legacy` as short-lived diagnostic scaffolding. The modern default is faster and getting ongoing JDK improvements; you want to land there as soon as your code stops assuming iteration order.

## Bonus: pre-7.1 session deserialisation

If you persist application/session scope across JVM restarts (clustering, file-backed scope, `objectSave`/`objectLoad` to disk), 7.1 broke that too — pre-7.1 sessions hit `InvalidClassException` because `ConcurrentHashMapNullSupport`'s field layout and `serialVersionUID` changed in LDEV-5098.

LDEV-6288 also fixes this: the pre-7.1 segmented implementation is restored under its original class name with its original UID, so 7.1 can read pre-7.1 session data transparently regardless of the `lucee.concurrent.map.impl` flag setting. You don't need to do anything for back-compat — it just works.

## Verifying the flag is active

Confirm Lucee picked up the system property:

```cfm
<cfscript>
dump( server.system.properties[ "lucee.concurrent.map.impl" ] ?: "(unset — JDK default)" );
</cfscript>
```

Expected output:

- Flag unset → `(unset — JDK default)`
- Flag set to `legacy` → `legacy`

`MapFactory` reads the property once at class init and stores the result in a `static final` constant — there's no per-call path that could silently ignore it, so seeing the value here is sufficient confirmation that the dispatch will honour it.

Under the hood, the two backing classes are:

- Default JDK impl: `lucee.commons.collection.concurrent.ConcurrentHashMapNullSupportJDK`
- `legacy`: `lucee.commons.collection.concurrent.ConcurrentHashMapNullSupport`

The class names reflect the back-compat rename — see [LDEV-6288](https://luceeserver.atlassian.net/browse/LDEV-6288) if you're curious about the why.

## Performance expectations

`legacy` is consistently 3-8% slower than the default on struct microbenchmarks under thread contention.

That's the price of restoring the old impl — it's pre-Java-8 segmented locking, vs. the JDK's CAS-based bucket design. Don't leave the flag on after fixing your code.

## Gotchas

**Only `normal` structs are affected.** `lucee.concurrent.map.impl` only changes the backing map for the `normal` struct type — what `{}` and `structNew()` give you by default. Any other struct flavour has its own backing map and is untouched:

| `structNew()` type | Backing map (default flag setting) | Affected? |
| --- | --- | --- |
| `normal` (default, thread-safe — what `{}` gives you) | `ConcurrentHashMapNullSupportJDK` wrapping JDK `ConcurrentHashMap` (or the segmented `ConcurrentHashMapNullSupport` under `legacy`) | **Yes** |
| `ordered` / `linked` | synchronised `LinkedHashMap` | No |
| `soft` | synchronised reference map with soft refs | No |
| `weak` | synchronised `WeakHashMap` | No |

If you've set `lucee.struct.type=linked` to make your default struct ordered, flipping `lucee.concurrent.map.impl` does nothing — your structs aren't backed by the affected wrapper. The two flags are orthogonal.

**Application/server scopes are unaffected.** Those use ordered-and-locked variants — different flavour from default structs. `legacy` doesn't change them.

## See also

- [LDEV-5098](https://luceeserver.atlassian.net/browse/LDEV-5098) — the 7.1 CHM replacement that introduced the regression
- [LDEV-6288](https://luceeserver.atlassian.net/browse/LDEV-6288) — this flag
