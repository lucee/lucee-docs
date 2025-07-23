# Lucee AST Demo

This Docker setup demonstrates Lucee's Abstract Syntax Tree (AST) functionality introduced in version 7.0.

## Quick Start

1. Start the container:
```bash
docker compose up -d
```

2. Open your browser:
```
http://localhost:8888
```

## What This Demonstrates

The demo shows two ways to generate AST from CFML code:

### Built-in Functions
- `astFromPath()` - Parse CFML files into AST
- `astFromString()` - Parse CFML code strings into AST

### Java Class Integration
- `lucee.runtime.util.AstUtil` - Direct Java class access for advanced usage

## Example Output

The AST is returned as a structured representation using neutral node types following ESTree conventions:
- `BinaryExpression`, `StringLiteral`, `NumberLiteral`
- `IfStatement`, `ForStatement`, `FunctionDeclaration`
- CFML-specific nodes like `CFMLTag`

Each node includes source position information (line, column, offset) for precise mapping.

## Requirements

- Docker and Docker Compose
- Lucee 7.0.0.299-SNAPSHOT or later

## File Structure

```
├── docker-compose.yml
└── www/
    └── index.cfm    # Demo template
```
