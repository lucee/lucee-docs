<!--
{
  "title": "CFML Keywords",
  "id": "cfml-keywords",
  "categories": ["core", "development", "tooling"],
  "description": "The keywords the Lucee compiler understands in script and tag syntax, grouped, plus where to get tag and function lists at runtime",
  "keywords": [
    "keywords",
    "reserved words",
    "syntax highlighting",
    "operators",
    "scopes",
    "modifiers",
    "return",
    "break",
    "continue",
    "abort",
    "rethrow",
    "editor",
    "UDL",
    "language definition"
  ],
  "related": [
    "tag-script",
    "tag-syntax",
    "tag-islands",
    "ast",
    "mcp",
    "language-server-protocol",
    "function-gettaglist",
    "function-gettagdata",
    "function-getfunctionlist",
    "function-getfunctiondata",
    "function-getfunctionkeywords",
    "function-astfrompath",
    "function-astfromstring"
  ]
}
-->

# CFML Keywords

Editors, syntax highlighters, linters and other tooling often need a list of the CFML keywords. This recipe lists what the Lucee compiler itself handles, grouped by purpose.

CFML has no single "reserved words" table. The keywords come from three different places in the compiler:

1. **Hard coded** in the expression and script parsers. These are the operators, literals, scopes, modifiers and statements (`if`, `for`, `return` and so on).
2. **Data driven** by the tag definitions (TLD files). Every tag that can be used in script, like `abort`, `break` or `lock`, is declared there. Extensions add more tags, so this part is open ended.
3. **Data driven** by the function definitions (FLD files). The built-in functions are not keywords, they are only names in the function library. Use the runtime lookups below for both lists.

The groups below only contain what the compiler handles. Where something is not a compiler keyword but is often mistaken for one, that is noted.

All keywords are case-insensitive.

## Statements without arguments

These can be written in script as a single word followed by a semicolon.

| Keyword | Notes |
| --- | --- |
| `return` | Hard coded in the script parser. With or without an expression. |
| `break` | Defined as a tag with the script type `single`. Takes an optional `label`. |
| `continue` | Defined as a tag with the script type `single`. Takes an optional `label`. |
| `abort` | Defined as a tag with the script type `single`. |
| `exit` | Defined as a tag with the script type `single`. |
| `rethrow` | Defined as a tag with the script type `single`. |
| `retry` | Defined as a tag with the script type `single`. |
| `silent` | Defined as a tag with the script type `single`. |

`return` is the only one of these built into the script parser itself. The others are ordinary tags that happen to need no attributes. See [[tag-script]] for how tags are written in script.

## Control flow

Hard coded in the script parser:

`if`, `else if`, `else`, `switch`, `case`, `default`, `for`, `in` (inside `for ( x in y )`), `while`, `do` ... `while`, `try`, `catch`, `finally`

Notes:

- `else if` is written as two words in script. `elseif` exists only as a tag.
- `case` and `default` only have meaning inside a `switch` body.
- `catch ( type name )` takes an exception type and a variable name. The type, like `any`, is not a keyword.
- `break` and `continue` (see above) are used inside loops and `switch`.

## Declarations

| Keyword | Where | Notes |
| --- | --- | --- |
| `component` | script and tag | Starts a component. Can be preceded by `abstract` or `final`. |
| `interface` | script and tag | Starts an interface. |
| `function` | script and tag | Named functions, and closures when used as an expression. |
| `property` | inside components | Declares a component property. |
| `param` | script and tag | Declares a variable with a default value. |
| `import` | script and tag | Imports a component or Java package for the current file. |
| `static` | inside components | `static { }` block, and also a function modifier. |
| `var` | inside functions | Declares a local variable. It is handled as a scope (see below). |

Arrow functions (`=>`) are written with the same rules as `function`, they only have a shorter body syntax.

`extends`, `implements`, `output`, `persistent` and similar words are **attributes** of `component` and `interface`, not keywords of their own.

## Modifiers

| Keyword | Applies to | Source of truth |
| --- | --- | --- |
| `public`, `private`, `package`, `remote` | functions, and variables inside components (`remote` is only valid on functions) | access modifiers |
| `abstract`, `final` | components and functions | component modifier |
| `final` | variables inside components, arguments | variable modifier |
| `static` | functions | static function |
| `required` | arguments | argument modifier |

## Creating objects

| Keyword | Notes |
| --- | --- |
| `new` | `new Foo()` and `new java:java.util.ArrayList()`. Only recognised when followed by a component path and `(`. |
| `java:`, `class:` | Prefix that selects a Java class, for example `new java:java.lang.StringBuilder()`. |
| `cfml:`, `cfc:` | Prefix that selects a CFML component, for example `new cfc:Foo()`. |
| `::` | Static scope access, for example `Foo::bar()` or `super::bar()`. |

Use `new` and the `::` operator in new code. The `createObject()` function is not needed for any of this.

## Literals

| Keyword | Notes |
| --- | --- |
| `true`, `false` | Boolean literals. |
| `null` | The null literal. Not treated as a literal when followed by `.` or `[`, so `null.foo` is a variable access. |

`yes` and `no` are **not** literals in the expression parser. They are only converted to booleans when they are cast, for example when used as an attribute value.

## Word operators

These are written as words instead of symbols. Several have more than one spelling.

| Operator | Spellings |
| --- | --- |
| Logical | `and`, `or`, `not`, `xor`, `eqv`, `imp` |
| Equality | `eq`, `equal`, `is` |
| Inequality | `neq`, `not equal`, `is not` |
| Comparison | `gt`, `greater than`, `gte`, `ge`, `greater than or equal to`, `lt`, `less than`, `lte`, `le`, `less than or equal to` |
| String search | `contains`, `ct`, `does not contain`, `nct` |
| Math | `mod`, `exp` |

The symbol operators (`&&`, `||`, `==`, `!=`, `<`, `>`, `+`, `-`, `*`, `/`, `%`, `^`, `\`, `&`, `?:`, `?.`, `++`, `--`, `+=`, `-=` and so on) are not keywords, so they are not listed here.

## Scopes

The expression parser treats these names specially when they start a variable:

`var`, `local`, `variables`, `arguments`, `request`, `server`, `thread`, `cgi`, `url`, `form`, `session`, `application`, `client`, `cookie`

`this` and `static` are handled separately when the variable is compiled, and `super` is handled in `super::`.

A few scopes are only recognised when the compiler is not told to ignore scopes (`cgi`, `url`, `form`, `session`, `application`, `client`, `cookie`). Names that exist as scopes at runtime but are not in the list above, such as `caller`, are not matched by the expression parser's scope handling.

## Tags in script

Any tag that is flagged for script use in its tag definition can be written without angle brackets. Each such tag is flagged as one of:

- `single`, a statement with attributes, for example `abort`, `include`, `throw`, `sleep`, `import`
- `multiple`, a statement with named attributes and an optional body, for example `lock`, `loop`, `query`, `transaction`, `thread`, `http`, `file`, `component`
- `none`, tag only, no script form

There is also the generic prefix form `cfname( attr=value );` which works for any core tag with a script definition.

A plain `cf` tag name like `cfloop` is not a keyword in script. The list of script capable tags depends on the installed extensions, so it should be read at runtime and not copied into an editor definition.

Use the runtime lookups below to get the authoritative list for the engine you are talking to.

## Getting tag and function lists at runtime

The built-in functions and tags are not hard coded in the compiler. They are loaded from definition files, and extensions can add more. These functions expose the same data the compiler uses.

| Function | Returns |
| --- | --- |
| [[function-gettaglist]] | Struct with one key per tag library. Each value is a struct whose keys are the tag names. Hidden and unimplemented tags are skipped. |
| [[function-gettagdata]] | Details for one tag, such as attributes, body type, description and `script` ( `type`, `rtexpr` ). |
| [[function-getfunctionlist]] | Struct whose keys are the function names. Hidden and unimplemented functions are skipped. |
| [[function-getfunctiondata]] | Details for one function, such as arguments, return type, description and status. |

```cfml
<cfscript>
	// every tag in the core tag library, which flags are set for script use
	tags = getTagList();
	for ( name in structKeyArray( tags.cf ) ) {
		data = getTagData( "cf", name );
		if ( data.script.type != "none" ) {
			systemOutput( name & " : " & data.script.type, true );
		}
	}

	// every function name
	functionNames = structKeyArray( getFunctionList() );

	// everything about one function
	systemOutput( getFunctionData( "arrayAppend" ), true );
</cfscript>
```

### What about `getFunctionKeywords()`?

[[function-getfunctionkeywords]] is **not** a list of reserved words. It returns the search keywords that the function definitions are tagged with, and is meant for finding functions by topic. Do not use it to get keywords for syntax highlighting.

### Version information

The tag and function definitions can carry an `introduced` value, which `getTagData()` and `getFunctionData()` return when it is set. That field is only filled in for **some** items, so it can not be used to tell when every tag or function was added. If a key `introduced` is missing, it means the information was not recorded, it does not mean the item has always existed.

The same applies to the compiler keywords on this page. There is no version metadata for them.

## Lucee MCP service

Lucee runs a public MCP service that gives AI tools and scripts the same function and tag definitions, full-text search over the documentation, and CFML AST parsing. The tools are `get_lucee_function`, `get_lucee_tag`, `search_lucee_docs`, `parse_cfml_ast` and `query_cfml_ast`. See [[mcp]] for the endpoint and how to connect a client.

## AST functions

If a tool needs to understand the structure of CFML code and not only list its keywords, the compiler can produce an AST for it:

- [[function-astfrompath]] parses a file.
- [[function-astfromstring]] parses a string, as tag or script code.

See [[ast]] for the node types, and [[language-server-protocol]] for how editors can use that.

## Configuration schema and environment variables

The Lucee build publishes machine-readable descriptions of the server configuration next to the main `org.lucee:lucee` artifact on Maven Central:

| File | Content |
| --- | --- |
| `lucee-<version>-config-schema.json` | JSON schema for the `.CFConfig.json` file |
| `lucee-<version>-env-vars.json` | The environment variables and system properties Lucee reads |

These files are only attached to the more recent release lines, so check the version directory on Maven Central before relying on them. They describe configuration, not language keywords, but editors can use them to offer completion and validation for the config file.

## Using this list

A syntax definition for an editor typically needs:

1. the **fixed groups** on this page (statements, control flow, declarations, modifiers, literals, operators, scopes)
2. the **tag names** from `getTagList()`, optionally marked by the script type from `getTagData()`
3. the **function names** from `getFunctionList()`

Items 2 and 3 can change with the Lucee version and the installed extensions, so generate them from a running server and do not copy them by hand.
