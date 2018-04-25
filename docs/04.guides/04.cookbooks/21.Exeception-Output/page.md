---
title: Exception Output
id: exception-output
related:
- tag-catch
- tag-rethrow
- tag-throw
- tag-try
categories:
- debugging
---

## Output Exceptions ##
This is how you catch and display Lucee exceptions to the web browser.

#### Example ####

```lucee
<cfscript>
try {
  throw "an error happened";
}
catch ( any e ){
  dump(e);
}
</cfscript>
Go on with your code
```

Result

[[tag-Dump]] shows the full exception structure without blocking your code. Dump include all stack trace with it.

#### Example 2 ####

```lucee
<cfscript>
try {
  throw "an error happened";
}
catch ( any e ){
  echo(e);
}
</cfscript>
Go on with your code
```

Here we simply echo the exception, It shows the normal exception without blocking your code.

<https://www.youtube.com/watch?v=vM-4R2A-ZsM>
