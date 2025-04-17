<!--
{
  "title": "Language Server Protocol (LSP) for Lucee",
  "id": "language-server-protocol",
  "since": "6.1",
  "description": "This document explains how to configure and use the Language Server Protocol implementation for Lucee CFML/CFScript.",
  "keywords": [
    "LSP",
    "language server",
    "IDE integration",
    "VS Code",
    "development tools",
    "code completion"
  ]
}
-->

# Language Server Protocol (LSP) for Lucee

**Experimental Feature**: The Language Server Protocol implementation is available as an experimental feature in Lucee 6.1 and above. As an experimental feature, it may undergo changes or improvements in future releases.

The Lucee Language Server Protocol implementation provides modern IDE features for Lucee CFML/CFScript development. It enables features like code completion, go to definition, and syntax validation in compatible editors like VS Code.

## Configuration

The LSP server can be configured using either environment variables or system properties. Both methods support the same configuration options.

### Environment Variables

```bash
# Enable/disable the LSP server (default: false)
export LUCEE_LSP_ENABLED=true

# Set the port number (default: 2089)
export LUCEE_LSP_PORT=2089

# Configure the CFML component that handles LSP requests
export LUCEE_LSP_COMPONENT="org.lucee.cfml.lsp.LSPEndpoint"

# Control component instance reuse (default: false)
export LUCEE_LSP_STATELESS=false
```

### System Properties

The same settings can be configured using Java system properties:

```bash
-Dlucee.lsp.enabled=true
-Dlucee.lsp.port=2089
-Dlucee.lsp.component=org.lucee.cfml.lsp.LSPEndpoint
-Dlucee.lsp.stateless=false
```

## Configuration Options

| Option | Description | Default Value |
|--------|-------------|---------------|
| lucee.lsp.enabled | Enables/disables the LSP server | false |
| lucee.lsp.port | Port number for the LSP server | 2089 |
| lucee.lsp.component | CFML component that handles LSP requests | org.lucee.cfml.lsp.LSPEndpoint |
| lucee.lsp.stateless | When false, reuses the same component instance for all requests. When true, creates a new instance for each request. | false |

## Component Implementation

The LSP server delegates all language-specific functionality to a CFML component. By default, this component is located at:

```
{lucee-root-directory}/lucee-server/context/components/org/lucee/cfml/lsp/LSPEndpoint.cfc
```

The component must implement the `execute` method that receives JSON-formatted LSP messages:

```cfml
// org/lucee/cfml/lsp/LSPEndpoint.cfc
component {
    public string function execute(required string jsonMessage) {
        var json=deserializeJSON(jsonMessage);
        systemOutput(json,1,1);
        json.addition="myAddition";
        return serializeJSON(json);
    }
}
```

You can customize the location of this component using the `lucee.lsp.component` configuration option.

## Logging

The LSP server logs its activity to Lucee's logging system. By default, it uses the 'debug' log (temporary because this is info by default), 
but you can configure a specific 'lsp' log in your Lucee configuration.

## Startup and Shutdown

The LSP server automatically starts when Lucee initializes if `lucee.lsp.enabled` is set to true. It runs in a daemon thread and will automatically shut down when Lucee stops.
