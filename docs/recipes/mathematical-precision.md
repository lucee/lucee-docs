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
writeOutput( 0.29 * 100 ); // 29 — the output is rounded for display
writeOutput( numberFormat( 0.29 * 100, "0.999999999999999" ) ); // 28.999999999999996
writeOutput( int( 0.29 * 100 ) ); // 28 — not 29!
writeOutput( ( 0.1 + 0.2 ) == 0.3 ); // false
```

Note that the displayed value hides the error: `0.29 * 100` is output as `29`, but the value underneath is still `28.999999999999996`.

## Approaches to Precise Math

Lucee supports BigDecimal-based precise math, which eliminates these floating point surprises. **Precise math is disabled by default** in both Lucee 6.2 and 7.0.

All math is slower in precise mode, so enable it only where you need it.

There are four ways to enable it, from narrowest to broadest scope:

### PrecisionEvaluate()

Wrap individual expressions that need exact results. Pass the expression as a **string**, so it is evaluated with precise math:

```lucee
writeOutput( int( PrecisionEvaluate( "0.29 * 100" ) ) ); // 29
writeOutput( PrecisionEvaluate( "0.1 + 0.2" ) == 0.3 ); // true
```

`PrecisionEvaluate()` can only make the calculation it evaluates precise. It can't fix a value that was already calculated with doubles before it was called:

```lucee
// Don't: x was already calculated with doubles
x = 0.29 * 100;                                  // 28.999999999999996
writeOutput( int( PrecisionEvaluate( x ) ) );    // 28
writeOutput( int( PrecisionEvaluate( "x" ) ) );  // 28

// Don't: the multiplication happens inside the function, with doubles
function times100( n ) { return n * 100; }
writeOutput( int( PrecisionEvaluate( times100( 0.29 ) ) ) ); // 28
```

(Arithmetic written directly inside the call, like `PrecisionEvaluate( 0.29 * 100 )`, is rewritten by the compiler and does give `29`, but as soon as a part of it is a value calculated earlier, it's too late. Passing a string makes the intent clear.)

### Toggle per request

Turn precise math on for just the section of code that needs it, then turn it off again (see [[update-application-context]]).

This is often the best approach — you get exact results where they matter without slowing down the rest of your request:

```lucee
application action="update" preciseMath="true";
writeOutput( int( 0.29 * 100 ) ); // 29
writeOutput( ( 0.1 + 0.2 ) == 0.3 ); // true
application action="update" preciseMath="false";
```

Only the operations done while the setting is on are precise. See the next section for what that means for values calculated before or after.

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

## Once a Value Is a Double, the Precision Is Lost

A double is a binary floating point number. As soon as a calculation is done with doubles, the result is rounded to the nearest binary value, and that rounding error is now part of the value. Turning precise math on afterwards, or passing the value to `PrecisionEvaluate()`, can't bring the exact result back.

This is why, when precise math is **not** enabled application- or server-wide, it isn't only the one operation you care about that matters, but every place the numbers are handled before it: values calculated earlier in the request, arguments passed to functions, the calculations those functions do, and their return values. Any of these may already be a double, with the error built in.

```lucee
total = 0.1 + 0.2;  // calculated with doubles: 0.30000000000000004
x = 0.29 * 100;     // calculated with doubles: 28.999999999999996

application action="update" preciseMath="true";
writeOutput( total == 0.3 );      // false — the error is already in the value
writeOutput( int( x ) );          // 28
writeOutput( x * 1 );             // 28.999999999999996
writeOutput( int( 0.29 * 100 ) ); // 29 — calculated while the setting is on
z = 0.1 + 0.2;                    // exactly 0.3
application action="update" preciseMath="false";

writeOutput( z == 0.3 ); // true
writeOutput( numberFormat( z * 3, "0.9999999999999999" ) ); // 0.8999999999999999 — calculated with doubles again
```

A value created with precise math stays exact, but the next calculation done with the setting off is done with doubles again.

So when you toggle precise math per request or use `PrecisionEvaluate()`, make sure the values reach it unrounded: as strings (for example `"19.99"`), as literals in the precise section, or as values calculated while precise math was on. If you need precise results across your whole codebase, enable it application- or server-wide instead.

## History

Lucee 6.0 initially shipped with BigDecimal math enabled by default. However, the performance impact was significant, so Lucee 6.2 reverted the default back to double-precision. It has remained opt-in since.

## Working with Money

A common approach for handling currency — in any language, not just CFML — is to store and calculate in the smallest unit (e.g. cents) as integers, sidestepping floating point entirely:

```lucee
// Bad: floating point dollars
total = 0.1 + 0.2; // displays as 0.3, but is 0.30000000000000004
writeOutput( total == 0.3 ); // false

// Good: work in cents as integers
totalCents = 10 + 20; // 30, always exact
dollars = totalCents \ 100; // integer division
cents = totalCents % 100;
writeOutput( "$#dollars#.#numberFormat( cents, '00' )#" ); // $0.30
```

This is a data modelling choice — keep values as integers throughout your business logic and only format for display at the boundary. It has no performance overhead and doesn't depend on any runtime setting.

For more complex calculations like percentages or tax where you can't avoid decimals, toggle precise math on for that section of code, and make sure the amounts going into it weren't already calculated with doubles (see above).

## Working with Geospatial Data

Latitude and longitude values require high decimal precision — a difference at the 6th decimal place represents roughly 0.11 metres. Floating point rounding errors can silently shift coordinates, which matters when calculating distances, geofences, or storing precise locations.

Toggle precise math on when performing geospatial arithmetic to ensure coordinates aren't silently rounded. As with money, this only helps if the coordinates reach that code unrounded (for example as strings from the database or the request), not as results of earlier double calculations.

Trigonometric functions such as `sin()` are still calculated with doubles, so precise math doesn't make them more precise. `numberFormat( sin( 0.5 ), "0.999999999999999" )` returns `0.479425538604203` with the setting on or off.
