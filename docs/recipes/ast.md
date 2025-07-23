<!--
{
  "title": "AST (Abstract Syntax Tree)",
  "id": "ast",
  "since": "7.0",
  "categories": ["development", "analysis", "tooling"],
  "description": "Generate Abstract Syntax Trees from CFML code for analysis, transformation, and tooling support",
  "keywords": [
    "AST",
    "Abstract Syntax Tree",
    "parsing",
    "code analysis",
    "static analysis",
    "transformation",
    "IDE tooling"
  ]
}
-->

# AST (Abstract Syntax Tree)

Lucee includes support for generating Abstract Syntax Trees (AST) from CFML code. An AST is a structured tree representation of the syntactic structure of source code, where each node represents a construct occurring in the programming language.

AST functionality enables advanced code analysis, IDE tooling, static analysis, code transformation, and automated documentation generation. The AST uses neutral, language-agnostic node types following ESTree conventions, making it compatible with existing tooling ecosystems.

## Use Cases

AST generation in Lucee supports various development and analysis scenarios:

- **Code Analysis**: Static analysis, complexity metrics, dependency tracking
- **IDE Tooling**: Syntax highlighting, autocomplete, refactoring support
- **Transformation**: Code generation, minification, transpilation
- **Documentation**: Automatic API documentation generation
- **Quality Assurance**: Linting, code style enforcement, security scanning
- **Migration Tools**: Converting between CFML versions or languages

## Built-in Functions

Lucee provides two built-in functions for AST generation:

### astFromPath()

Parses a CFML file and returns its AST representation.

```cfml
// Parse a CFC file
ast = astFromPath("/components/User.cfc");

// Parse using different path types
ast = astFromPath(expandPath("./template.cfm"));
ast = astFromPath("/absolute/path/to/file.cfm");

// The function accepts various path types:
// - String paths (relative or absolute)
// - java.io.File objects
// - lucee.commons.io.res.Resource objects
// - File streams opened with fileOpen()
```

### astFromString()

Parses CFML source code from a string and returns its AST representation.

```cfml
// Parse simple CFML code
ast = astFromString("<cfset name = 'John'>");

// Parse more complex code
cfmlCode = "
<cffunction name='calculateSum' returntype='numeric'>
    <cfargument name='a' type='numeric' required='true'>
    <cfargument name='b' type='numeric' required='false' default='0'>
    <cfreturn a + b>
</cffunction>";

ast = astFromString(cfmlCode);
```

## Java Class Integration

For more advanced usage or when building tools, you can directly use the `AstUtil` Java class:

```cfml
// Create an instance of AstUtil
astUtil = new lucee.runtime.util.AstUtil();

// Parse from string
ast = astUtil.astFromString("<cfset susi = 1>");

// Parse from file
ast = astUtil.astFromPath("/test1.cfm");
```

This approach is particularly useful when:

- Building extensions or plugins
- Creating development tools
- Performing batch analysis of multiple files
- Integrating with Java-based tooling

## AST Structure

The returned AST uses neutral, language-agnostic node types that follow ESTree conventions:

### Root 

```cfml
{
  "type": "Program",           // Root AST node
  "start": {...},             // Source position information
  "end": {...},               // Source position information
  "sourceType": "cfml",       // Language identifier
  "body": [...]               // Array of top-level statements
}
```

### Common Node Types

**Expressions:**

- `BinaryExpression` - Operations like `x + y`, `a && b`
- `UnaryExpression` - Operations like `!condition`, `-number`
- `CallExpression` - Function calls like `myFunction(arg1, arg2)`
- `MemberExpression` - Property access like `obj.property`
- `ConditionalExpression` - Ternary operator `condition ? true : false`

**Literals:**

- `StringLiteral` - String values like `"hello"`
- `NumberLiteral` - Numeric values like `42`, `3.14`
- `BooleanLiteral` - Boolean values `true`, `false`
- `NullLiteral` - Null values
- `ArrayExpression` - Array literals like `[1, 2, 3]`
- `ObjectExpression` - Struct literals like `{name: "value"}`

**Statements:**

- `IfStatement` - Conditional statements
- `ForStatement` - Traditional for loops
- `WhileStatement` - While loops
- `SwitchStatement` - Switch statements
- `TryStatement` - Try-catch-finally blocks
- `FunctionDeclaration` - Function definitions

**CFML-Specific:**

- `CFMLTag` - CFML tags like `<cfquery>`, `<cfloop>`
- `ClosureExpression` - Anonymous functions
- `LambdaExpression` - Arrow functions

### Source Position Information

Each AST node includes precise source location data:

```cfml
{
  "type": "StringLiteral",
  "value": "hello",
  "raw": "\"hello\"",
  "start": {"line": 1, "column": 8, "offset": 7},
  "end": {"line": 1, "column": 15, "offset": 14}
}
```

This information enables accurate error reporting, IDE integration, and source mapping.

## Practical Examples

### Analyzing Function Definitions

```cfml
cfmlCode = "
<cffunction name='calculateTax' returntype='numeric'>
    <cfargument name='amount' type='numeric' required='true'>
    <cfargument name='rate' type='numeric' default='0.08'>
    <cfreturn amount * rate>
</cffunction>";

ast = astFromString(cfmlCode);

// Navigate the AST to find function information
if (ast.type == "Program" && arrayLen(ast.body) > 0) {
    firstStatement = ast.body[1];
    if (firstStatement.type == "FunctionDeclaration") {
        writeOutput("Function name: " & firstStatement.id.name);
        writeOutput("Parameter count: " & arrayLen(firstStatement.params));
    }
}
```

## Integration with Development Tools

The AST functionality integrates well with various development scenarios:

### IDE Extensions

- Use AST for syntax highlighting
- Implement intelligent autocomplete
- Build refactoring tools

### Static Analysis Tools

- Detect code smells and anti-patterns
- Enforce coding standards
- Calculate complexity metrics

### Documentation Generators

- Extract function signatures and comments
- Generate API documentation automatically
- Create dependency graphs

## Docker Demo

A complete working example is available as a Docker setup:

**Repository**: [https://github.com/lucee/lucee-docs/tree/master/examples/docker/ast](https://github.com/lucee/lucee-docs/tree/master/examples/docker/ast)

The demo includes:

- Docker Compose configuration with Lucee 7.0.0.299-SNAPSHOT
- Example templates demonstrating both built-in functions and Java class usage
- Ready-to-run environment for testing AST functionality

```bash
# Clone and run the demo
git clone https://github.com/lucee/lucee-docs.git
cd lucee-docs/examples/docker/ast
docker-compose up -d
# Open http://localhost:8888
```

## Best Practices

When working with AST in Lucee:

1. **Handle Errors Gracefully**: Always wrap AST parsing in try-catch blocks
2. **Cache Results**: AST generation can be expensive for large files
3. **Use Appropriate Method**: Use `astFromPath()` for files, `astFromString()` for dynamic code
4. **Validate Input**: Ensure files exist and strings contain valid CFML
5. **Consider Memory Usage**: Large files generate large AST structures

The AST functionality opens new possibilities for CFML development tooling and analysis, enabling sophisticated code analysis and transformation capabilities that were previously difficult to achieve.