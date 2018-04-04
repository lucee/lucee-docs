---
title: Exception Output
id: exception-output
---
## Output Exceptions ##
Here we can see how the lucee output the exception on web browser.

#### Example ####

```lucee
<cfscript>
try {
  throw "shit happens";
}
catch ( any e ){
  dump(e);
}
</cfscript>
Go on with your code
```

Result

Dump shows full exception structure without blocking your code. Dump include all stack trace with it.

#### Example 2 ####

```lucee
<cfscript>
try {
  throw "shit happens";
}
catch ( any e ){
  echo(e);
}
</cfscript>
Go on with your code
```

Here we simply echo the exception, It shows the normal exception without blocking your code.

### Footnotes ###

[Lucee Exception output video ](https://www.youtube.com/watch?v=vM-4R2A-ZsM)

