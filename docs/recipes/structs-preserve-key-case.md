<!--
{
  "title": "Structures and variables, preserving the original case",
  "id": "struct-preserve-key-case",
  "categories": ["struct", "best-practices", "components"],
  "description": "How to configure preserve case for struct keys",
  "keywords": [
    "struct",
    "dotNotationUpperCase",
    "preserve case"
  ],
  "related": [
    "tag-processingdirective",
    "tag-setting",
    "function-structnew",
    "scopes"
  ]
}
-->

# Preserving Key Case in CFML Structs / Variables

## The Problem

You're building a REST API and returning a struct as JSON. Your code looks clean:

```lucee
sct = {};
sct.firstName = "James";
sct.lastName = "Kirk";
serializeJSON( sct );
```

But the JSON output has uppercase keys:

```json
{"FIRSTNAME":"James","LASTNAME":"Kirk"}
```

Your JavaScript frontend expects `firstName`, not `FIRSTNAME`. What's going on?

## Why This Happens

In CFML, variable names are **case-insensitive**. To achieve this, Lucee converts all keys defined with dot notation to uppercase at compile time. This is the traditional CFML behaviour.

```lucee
sct = {};
sct.firstName = "James";      // Would be stored as "FIRSTNAME"
sct["firstName"] = "Jamez";   // Would be still stored as "FIRSTNAME" (see note)
sct["lastName"] = "Kirk";   // Would be stored as "lastName" (bracket notation preserves case)
```

Note: in the above example, once a key is created, updating it will not change the key case, so `sct["firstName"]` does not change the original key case.

All variables in Lucee are stored in structs under the hood - `variables`, `local`, `arguments`, `url`, `form` - they all follow the same rules.

## Solutions

### Use Bracket Notation

Bracket notation **always** preserves case:

```lucee
sct = {};
sct["firstName"] = "James";
sct["lastName"] = "Kirk";
```

### Server-Wide Configuration

If you want dot notation to preserve case everywhere, Lucee has a compiler setting called `dotNotationUpperCase`.

- **`true`** (default): Convert dot notation keys to uppercase (CFML standard)
- **`false`**: Preserve the original case

#### Configuring via Lucee Admin

1. Open the Lucee Server or Web Admin
2. Navigate to **Settings → Language/Compiler**
3. Under **Key Case**, select "Preserve case"

#### Configuring via .CFConfig.json

```json
{
  "dotNotationUpperCase": false
}
```

#### Configuring via Environment Variable

```bash
LUCEE_PRESERVE_CASE=true
```

Or as a system property:

```bash
-Dlucee.preserve.case=true
```

Note: The environment variable uses **preserve case** logic (inverse of `dotNotationUpperCase`), so `true` means preserve case.

## Per-Template Override

You can override the server setting for a specific template using [[tag-processingdirective]]

```lucee
<cfprocessingdirective preserveCase="true">

<cfscript>
sct = {};
sct.firstName = "James";  // Preserved as "firstName" in this template
</cfscript>
```

## Checking the Current Setting

You can check what setting is active:

```lucee
settings = getApplicationSettings();
writeOutput( settings.dotNotationUpperCase );  // true or false
```

## Things to Consider

When set via the Lucee Admin / `CFConfig.json`, keep in mind this is server wide configuation. 

If you're working with legacy code that assumes uppercase keys, switching to preserve case could break things. Test thoroughly.