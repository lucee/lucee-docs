<!--
{
  "title": "Mathematical Precision",
  "id": "mathematical-precision",
  "since": "6.0",
  "description": "Learn about the switch from double to BigDecimal in Lucee 6 for more precise mathematical operations. This guide provides information on how to change the default behavior if needed.",
  "keywords": [
    "CFML",
    "math",
    "precision",
    "BigDecimal",
    "Lucee",
    "Application.cfc",
    "PrecisionEvaluate"
  ],
  "related": [
    "function-precisionevaluate"
  ],
  "categories: [
    "math",
    "number"
  ]

}
-->

# Mathematical Precision

So far, Lucee has handled numbers internally as “double”, but with Lucee 6 we have added support for using “BigDecimal”. 

This makes math operations much more precise (but slower) and there is no need anymore to use the function “PrecisionEvaluate”.

Since version 6.0, all numbers Lucee uses in the runtime are by default BigDecimal based and no longer double as before. 

However, for performance reasons, with Lucee 6.2, we reverted the default to the old behavior as it's much faster.

You can toggle precise math in the `Application.cfc` as follows:

```lucee
this.preciseMath = true | false;
```

## Dynamically during a request

You also simply toggle precision on or off for the current request, only as required, which is recommended for best performance.

```lucee
application action="update" preciseMath="true|false";
```

## System Property / Environment Variable

You can also change that behavior with the system property `-Dlucee.precise.math=false` or with the environment variable `LUCEE_PRECISE_MATH=false`.
