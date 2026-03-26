<!--
{
  "title": "Mathematical Precision",
  "id": "mathematical-precision",
  "since": "6.0",
  "description": "Learn how to enable BigDecimal-based precise math in Lucee to avoid floating point issues. Precise math is opt-in and disabled by default.",
  "keywords": [
    "math",
    "precision",
    "BigDecimal",
    "Lucee",
    "Application.cfc",
    "PrecisionEvaluate",
    "preciseMath",
    "floating point",
    "money",
    "currency",
    "geospatial",
    "latitude",
    "longitude"
  ],
  "related": [
    "function-precisionevaluate"
  ],
  "categories": [
    "math",
    "core",
    "number"
  ]

}
-->

# Mathematical Precision

Virtually every programming language — Java, JavaScript, Python — uses IEEE 754 double-precision floating point for math by default, and CFML is no different. It's fast, but some decimal values simply can't be represented exactly in binary:

```lucee
// 0.29 * 100 is actually 28.999999999999996 as a double
writeOutput( numberFormat( 0.29 * 100, "0.999999999999999" ) ); // 28.999999999999996
writeOutput( int( 0.29 * 100 ) ); // 28 — not 29!
```

## Approaches to Precise Math

Lucee supports BigDecimal-based precise math, which eliminates these floating point surprises. **Precise math is disabled by default** in both Lucee 6.2 and 7.0.

All math is slower in precise mode, so enable it only where you need it.

There are four ways to enable it, from narrowest to broadest scope:

### PrecisionEvaluate()

Wrap individual expressions that need exact results:

```lucee
writeOutput( PrecisionEvaluate( 0.29 * 100 ) ); // 29
```

### Toggle per request

Turn precise math on for just the section of code that needs it, then turn it off again (see [[update-application-context]]).

This is often the best approach — you get exact results where they matter without slowing down the rest of your request:

```lucee
application action="update" preciseMath="true";
// precise math operations here
application action="update" preciseMath="false";
```

### Application-wide

Enable it for your entire application in `Application.cfc`:

```lucee
this.preciseMath = true;
```

### Server-wide

Enable it across all applications via system property or environment variable:

```
-Dlucee.precise.math=true
LUCEE_PRECISE_MATH=true
```

## History

Lucee 6.0 initially shipped with BigDecimal math enabled by default. However, the performance impact was significant, so Lucee 6.2 reverted the default back to double-precision. It has remained opt-in since.

## Working with Money

A common approach for handling currency — in any language, not just CFML — is to store and calculate in the smallest unit (e.g. cents) as integers, sidestepping floating point entirely:

```lucee
// Bad: floating point dollars
total = 0.1 + 0.2; // 0.30000000000000004

// Good: work in cents as integers
totalCents = 10 + 20; // 30, always exact
dollars = totalCents \ 100; // integer division
cents = totalCents % 100;
writeOutput( "$#dollars#.#numberFormat( cents, '00' )#" ); // $0.30
```

This is a data modelling choice — keep values as integers throughout your business logic and only format for display at the boundary. It has no performance overhead and doesn't depend on any runtime setting.

For more complex calculations like percentages or tax where you can't avoid decimals, toggle precise math on for that section of code.

## Working with Geospatial Data

Latitude and longitude values require high decimal precision — a difference at the 6th decimal place represents roughly 0.11 metres. Floating point rounding errors can silently shift coordinates, which matters when calculating distances, geofences, or storing precise locations.

Toggle precise math on when performing geospatial arithmetic to ensure coordinates aren't silently rounded.
