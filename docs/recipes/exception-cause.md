<!--
{
  "title": "Exception - Cause",
  "id": "exception-cause",
  "since": "6.1",
  "description": "Lucee 6.1 improves its support for exception causes, providing better debugging and error handling capabilities.",
  "keywords": [
    "exception",
    "error",
    "cause",
    "thread",
    "parent"
  ],
  "categories": [
    "debugging"
  ],
  "related": [
    "tag-throw"
  ]
}
-->

# Exception - Cause

Lucee 6.1 improves its support for exception causes, providing better debugging and error handling capabilities.

## Tag Attribute cause

The `<cfthrow>` tag now includes a `cause` attribute to chain exceptions:

```run
<cfscript>
try {
    try {
        throw "Upsi dupsi!";
    }
    catch(e) {
        cfthrow (message="Upsi daisy!", cause=e);
    }
}
catch(ex) {
    dump(ex.message);
    dump(ex.cause.message);
}
</cfscript>
```

This gives you the tag context and Java stack trace from both the top-level exception and its cause.

## Parent Thread Context

Exceptions from child threads (parallel `cfhttp`, `cfthread`) now include the parent thread's stack trace as the cause - previously you only saw the child thread's stack trace:

```run
<cfscript>
thread name="testexception" {
    throw "Upsi dupsi!"
}
threadJoin("testexception");
dump(cfthread["testexception"].error.message);
dump(cfthread["testexception"].error.cause.Message);
</cfscript>
```

The error includes both the exception from within `cfthread` and where it was called from, making debugging much easier.
