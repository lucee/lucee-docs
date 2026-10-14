<!--
{
  "title": "Diagnosing struct iteration-order regressions on 7.1 with `lucee.concurrent.map.impl=legacy`",
  "id": "concurrent-map-legacy-flag",
  "categories": ["struct", "compat", "debugging"],
  "menuTitle": "Legacy struct-ordering flag",
  "description": "The `lucee.concurrent.map.impl=legacy` flag temporarily restores the pre-7.1 struct iteration order, used as a diagnostic to confirm whether a 7.1 regression is an ordering-assumption bug in your code.",
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

# Diagnosing struct iteration-order regressions on 7.1 with `lucee.concurrent.map.impl=legacy`

Lucee 7.1 switched to using the JDK's `ConcurrentHashMap` for the backing map of regular `{}` structs ([LDEV-5098](https://luceeserver.atlassian.net/browse/LDEV-5098)), replacing a much older Java 7-era custom implementation that had been carried since the Railo days.

The new map is faster and gets ongoing JDK improvements for free, but it iterates keys in a **different order** than the old one. CFML structs have never guaranteed iteration order — `structNew("ordered")` is the supported way to get a stable ordering — but plenty of real-world code drifted into assuming the 7.0 order was stable. On 7.1, that code breaks quietly:

```cfml
var s = { "data": {}, "includes": ["a.js"], "adhoc": {} };
serializeJSON( s )
// 7.0: {"data":{},"includes":["a.js"],"adhoc":{}}
// 7.1: {"includes":["a.js"],"adhoc":{},"data":{}}
```

JSON-string comparisons in tests, hash digests built from `serializeJSON`, comma-lists composed from struct keys — all technically wrong but working on 7.0, and silently broken on 7.1.

[LDEV-6288](https://luceeserver.atlassian.net/browse/LDEV-6288) adds **`lucee.concurrent.map.impl=legacy`** as a diagnostic flag (since 7.1.0.105). Set it, restart, and Lucee uses the 7.0 implementation for default structs — restoring the old iteration order exactly. Use it to confirm a regression is genuinely an ordering-assumption bug, then fix the code and drop the flag.

The right fix is always to stop assuming an iteration order in your code, not to lock yourself to either the 7.0 or 7.1 order. The 7.1 order isn't itself stable across JDK versions or vendor builds.

## The workflow

You're testing on 7.1 and something broke — a serialised JSON string doesn't match, a test fails on a comma-list comparison, a cached fragment stopped matching.

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

   - **Breakage goes away?** Confirmed — your code was relying on the 7.0 ordering. Fix the code (use `structNew("ordered")`, sort keys before comparing, compare parsed structs instead of JSON strings), then **drop the flag** and run on the modern default. That's the destination — `legacy` was there to prove the diagnosis.
   - **Breakage persists?** It's not an ordering issue. Keep investigating without the flag. One common non-fix: tests that hardcode literal hash output like `fk_04256baa79b5ed9099b1dde0da7eb613` from `hash(serializeJSON(someStruct))` (this example is from Preside; the `fk_` prefix is Preside's foreign-key cache key convention). Those are cross-version fragile by design and `legacy` can't restore an exact hash value from an old Lucee+JDK combo — only a source fix (sort keys first, or hash deterministic content instead of the struct) resolves them.

Treat `legacy` as short-lived diagnostic scaffolding. The modern default is faster and gets ongoing JDK improvements; you want to land there as soon as your code stops assuming iteration order.

## Performance expectations

`legacy` is consistently 3-8% slower than the default on struct microbenchmarks under thread contention. That's the price of restoring the old implementation. Don't leave the flag on after fixing your code.

## Gotchas

**Only default structs are affected.** `lucee.concurrent.map.impl` only changes the backing map for the default `normal` struct — what `{}` and `structNew()` (no argument) produce. Other struct flavours have their own backing maps and aren't touched:

| `structNew()` type | Affected by flag? |
| --- | --- |
| `normal` (default — what `{}` gives you) | **Yes** |
| `ordered` / `linked` | No |
| `soft` | No |
| `weak` | No |

**`lucee.struct.type` is a different thing.** If you've used `lucee.struct.type=linked` to force `{}` to produce ordered structs by default, flipping `lucee.concurrent.map.impl` does nothing — your structs aren't backed by the affected map. The two flags are orthogonal.

**Application/server scopes are unaffected.** Those use ordered-and-locked struct flavours — `legacy` doesn't change them.

## See also

- [LDEV-5098](https://luceeserver.atlassian.net/browse/LDEV-5098) — the 7.1 change that shifted iteration order
- [LDEV-6288](https://luceeserver.atlassian.net/browse/LDEV-6288) — this flag
