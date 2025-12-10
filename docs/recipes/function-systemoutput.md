<!--
{
  "title": "SystemOutput, writing to the console",
  "id": "systemoutput-recipe",
  "description": "This document explains the systemoutput function with some simple examples.",
  "keywords": [
    "SystemOutput function",
    "Debugging",
    "Output stream",
    "Error stream",
    "Stack trace"
  ],
  "related":[
    "function-systemoutput"
  ],
  "categories":[
    "server",
    "debugging"
  ]
}
-->

# Function SystemOutput

[[function-systemOutput]] is like [[tag-dump]] for your console - supports complex types. Visible in Docker logs.

## Browser vs Console

```luceescript
dump(cgi); // browser output (or writeDump if you love to write more)
echo(now()); // browser output (or writeOutput if you love to write more)
systemOutput(cgi, true); // console output
systemOutput(now(), true); // console output
```

## New Line

```luceescript
systemOutput(now(), true); // with new line
```

Second argument `true` adds a newline.

## Error Stream

```luceescript
systemOutput(now(), true, true); // send to error stream
```

Third argument `true` writes to stderr instead of stdout.

## Complex Objects

```luceescript
systemOutput(cgi, true); // complex object
```

Outputs serialized representation of structs, queries, etc.

## Stack Trace

```luceescript
systemOutput("Here we are:<print-stack-trace>", true);
```

The `<print-stack-trace>` placeholder outputs the current stack trace.

Video: [Function SystemOutput](https://www.youtube.com/watch?v=X_BQPFPD320)
