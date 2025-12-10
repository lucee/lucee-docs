<!--
{
  "title": "Exception Output",
  "id": "exception-output",
  "related": [
    "tag-catch",
    "tag-rethrow",
    "tag-throw",
    "tag-try"
  ],
  "categories": [
    "debugging"
  ],
  "description": "How to catch and display exceptions.",
  "keywords": [
    "Exception",
    "Output",
    "Catch",
    "Display exceptions",
    "Lucee",
    "try-catch"
  ]
}
-->

# Exception Output

How to catch and display exceptions

## Using dump() for Full Exception Details

```run
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

[[tag-dump]] shows the full exception structure without blocking your code. Dump includes the full stack trace.

## Using echo() for Simple Output

```lucee
<cfscript>
try {
  throw "an error happened again!";
}
catch ( any e ){
  echo(e);
}
</cfscript>
Go on with your code
```

Here we simply echo the exception. It shows the normal exception without blocking your code.

[https://www.youtube.com/watch?v=vM-4R2A-ZsM](https://www.youtube.com/watch?v=vM-4R2A-ZsM)
