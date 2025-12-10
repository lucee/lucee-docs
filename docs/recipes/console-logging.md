<!--
{
  "title": "Console logging using SystemOutput",
  "id": "console-logging",
  "description": "Use the console for debugging",
  "keywords": [
    "Logging",
    "console"
  ],
  "related": [
    "function-systemoutput",
    "tag-log",
    "tag-dump",
    "function-writelog",
    "troubleshooting"
  ],
  "categories": [
    "server"
  ]
}
-->

# Console Logging

Most CFML developers are familiar with [[tag-dump]] for debugging. [[function-systemoutput]] is similar but writes to the console - useful for CLI scripts, background tasks, and CI environments.

Like [[tag-dump]], it can output both text and complex objects. The second argument `addNewLine` controls whether a newline is added (default: `false`).

## Access the Console

- **Tomcat**: `catalina run` in `tomcat\bin`
- **CommandBox**: `box server start --console`
- **CI/CD**: Output appears directly in job logs

## Example

```cfml
<cfscript>
	array = [ 1, "array", now() ]
	systemOutput( array, true );
	struct = { lts: 5.4, stable: 6.2 };
	systemOutput( struct, true );
	query = queryNew( "id,name", "numeric,varchar", [ [ 1, "lucee" ], [ 2, "ralio" ] ] );
	systemOutput( query, true );
	systemOutput( "starting ftp <print-stack-trace>", true );
</cfscript>
```

Produces the following output in the console:

```bash
[1,"array",createDateTime(2025,8,14,17,9,0,242,"Europe/Berlin")]
{"STABLE":6.2,"LTS":5.4}
query("id":[1,2],"name":["lucee","ralio"])
starting ftp
java.lang.Exception: Stack trace
        at lucee.runtime.functions.other.SystemOutput.call(SystemOutput.java:62)
        at lucee.runtime.functions.other.SystemOutput.call(SystemOutput.java:42)
        at console_cfm$cf$1.call(/console.cfm:8)
        at lucee.runtime.PageContextImpl._doInclude(PageContextImpl.java:1112)
        at lucee.runtime.PageContextImpl._doInclude(PageContextImpl.java:1006)
```