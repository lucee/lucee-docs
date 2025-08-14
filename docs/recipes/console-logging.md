<!--
{
  "title": "Console Logging using SystemOutput",
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

## Console Logging in Lucee

Most CFML developers are familiar with using [[tag-dump]] when debugging.

Lucee has a very useful function [[function-systemoutput]], which lets you write messages and dump objects to the console.

### What's the console?

If you are using Tomcat, you can run it interactively using `catalina run` in the `tomcat\bin` directory.

With [[getting-started-commandbox]], you can do similar, via `box server start --console`

Both then run the Server with the console logs being output.

### What can we log?

Similar to [[tag-dump]], [[function-systemoutput]] can output both text and complex objects.

By default, it doesn't output new lines, the second boolean argument, `addNewLine` does what it says.

### Use with CI like GitHub Actions

When you are running tests remotely, any output from [[function-systemoutput]] is then visible directly in the job log.

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