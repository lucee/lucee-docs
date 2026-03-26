<!--
{
  "title": "Lucee 7 Loader API Changes",
  "id": "loader-api-changes-7",
  "since": "7.0",
  "categories": ["java", "extensions"],
  "description": "New and changed interfaces in the Lucee 7 Loader API for extension and integration developers",
  "keywords": [
    "loader",
    "API",
    "CFMLEngine",
    "extensions",
    "Java",
    "Jakarta",
    "AI",
    "secret provider",
    "migration"
  ],
  "related": [
    "breaking-changes-6-2-to-7-0",
    "javax-jakarta",
    "ai",
    "secret-management",
    "extension-installation"
  ]
}
-->

# Lucee 7 Loader API Changes

The Loader API is the public Java interface that extensions, servlet containers, and embedding applications use to interact with Lucee. Lucee 7 introduces significant additions and refinements to this API.

This page covers **new and changed** interfaces only. For breaking changes and migration steps, see [[breaking-changes-6-2-to-7-0]].

## Loader Version History

The loader has its own internal version number (`lucee.loader.Version.VERSION`), separate from the Lucee release version. Extensions can declare a minimum loader version they require.

| Loader Version | Change | First appeared in |
| --- | --- | --- |
| **6.3** | Lucee 6.x loader | pre-Lucee 7 |
| **7.0** | AI interfaces moved from core to loader ([LDEV-5368](https://luceeserver.atlassian.net/browse/LDEV-5368)) | 7.0.0.114 |
| **7.1** | Loader version requirement update | 7.0.0.126 |
| **7.2** | Loader version update | Not yet released |

Note that early Lucee 7 builds still used loader version 6.3 — the javax→jakarta servlet migration was already in place before the loader version was bumped to 7.0.

## CFMLEngine Changes

`CFMLEngine` is the primary entry point for interacting with Lucee from Java. Several methods have been added or deprecated.

### New Methods

```java
// AI utility — access AI engine management and response handling
public AI getAIUtil();

// Typed JavaProxyUtil — replaces the untyped Object return
public JavaProxyUtil getJavaProxy();

// Thread PageContext with clone option
public PageContext getThreadPageContext( boolean cloneParentIfNotExist );

// Fixed typo from Lucee 6's getOperatonUtil()
public Operation getOperationUtil();

// Dialect-neutral script/tag engine factories
public ScriptEngineFactory getScriptEngineFactory();
public ScriptEngineFactory getTagEngineFactory();
```

### Deprecated Methods

| Method | Replacement |
| --------- | --------------- |
| `getOperatonUtil()` | `getOperationUtil()` |
| `getScriptEngineFactory( int dialect )` | `getScriptEngineFactory()` |
| `getTagEngineFactory( int dialect )` | `getTagEngineFactory()` |

### Servlet Import Change

All servlet types in `CFMLEngine` now use `jakarta.servlet.*` imports instead of `javax.servlet.*`. The method signatures are otherwise identical — if your extension compiles against the loader jar, you will need to update your imports.

## New AI Subsystem (`lucee.runtime.ai.*`)

A complete AI integration API has been added. These interfaces back the CFML AI functions (`AICreateSession`, `AIChat`, etc.).

### Key Interfaces

- **`AIEngine`** — represents a configured AI provider (OpenAI, Gemini, Ollama, etc.)
- **`AISession`** — a conversation session with an AI engine
- **`AIEmbeddingSession`** — session for generating embeddings
- **`AISessionMultiParts`** — session supporting multipart content (images, PDFs)
- **`AIModel`** — metadata about an available model
- **`AIFile` / `AIEngineFile`** — file references for AI operations
- **`Conversation`** — conversation history container
- **`Request` / `Response`** — request and response wrappers
- **`Part`** — individual content part (text, image, etc.)
- **`AIResponseListener`** — listener for streaming responses

### AI Utility Interface

The new `lucee.runtime.util.AI` interface (accessed via `CFMLEngine.getAIUtil()`) provides helper methods:

```java
public interface AI {
    public void valdate( AIEngine aie, int connectTimeout, int socketTimeout ) throws PageException;
    public List<String> getModelNames( AIEngine aie );
    public String findModelName( AIEngine aie, String name );
    public String getModelNamesAsStringList( AIEngine aie );
    public Struct getMetaData( AIEngine aie, boolean addModelsInfo, boolean addFilesInfo ) throws PageException;
    public String extractStringAnswer( Response rsp );
    public List<Part> getAnswersFromAnswer( Response rsp );
}
```

See [[ai]] for CFML-level usage.

## New JavaProxyUtil Interface

In Lucee 6, `CFMLEngine.getJavaProxyUtil()` returned an untyped `Object`. Lucee 7 adds a properly typed alternative:

```java
// Lucee 6 (still available but untyped)
public Object getJavaProxyUtil();

// Lucee 7 (new, typed)
public JavaProxyUtil getJavaProxy();
```

`JavaProxyUtil` provides methods for calling CFC methods from Java and converting between Java and CFML types:

```java
public interface JavaProxyUtil {
    public Object call( ConfigWeb config, Component cfc, String methodName, Object... arguments );
    public Object call( ConfigWeb config, UDF udf, String methodName, Object... arguments );
    // Type conversion helpers: toBoolean, toInt, toDouble, toLong, toString, to(obj, class), toCFML(value), etc.
}
```

## New Security Interfaces

### SecretProvider and SecretProviderExtended

New interfaces for implementing custom secret management providers. These back the [[secret-management]] feature.

- **`lucee.runtime.security.SecretProvider`** — base interface for secret providers
- **`lucee.runtime.security.SecretProviderExtended`** — extended interface with additional capabilities

## "Pro" Extension Interfaces (Now in the Loader)

Lucee 7 exposes "Pro" variants of existing interfaces in the public loader API. These existed in Lucee 6's internal core but were not available to extensions — they are now part of the stable public API:

- **`lucee.runtime.cache.tag.CacheHandlerPro`** — extends `CacheHandler` with additional cache management methods (moved from core to loader)
- **`lucee.runtime.db.DataSourcePro`** — extends `DataSource` with advanced datasource configuration (moved from core to loader)
- **`lucee.runtime.search.SearchDataPro`** — extends `SearchData` with additional search capabilities (new in 7.0.3.30, [LDEV-6196](https://luceeserver.atlassian.net/browse/LDEV-6196))

If your extension implements the base interface, it will continue to work. Implementing the "Pro" variant opts in to the new functionality.

## New Listener Interfaces

- **`lucee.runtime.spooler.listener.SpoolerTaskListener`** — listen for spooler task events (completion, failure)
- **`lucee.runtime.tag.listener.TagListener`** — listen for tag execution events
- **`lucee.runtime.listener.AuthCookieData`** — authentication cookie data structure
- **`lucee.runtime.listener.CookieData`** — generic cookie data interface
- **`lucee.runtime.listener.SessionCookieData`** — session cookie data
- **`lucee.runtime.listener.ISerializationSettings`** — serialization configuration

## New Utility Types

- **`lucee.commons.lang.Pair<K, V>`** — generic key-value pair, implements `Serializable`
- **`lucee.runtime.type.Pojox`** — enhanced POJO type support
- **`lucee.runtime.regex.Regex`** — first-class regex handling interface
- **`lucee.runtime.db.ParamSyntax`** — parameterized SQL syntax interface
- **`lucee.runtime.util.AstUtil`** — AST (Abstract Syntax Tree) utility
- **`lucee.commons.io.res.type.ftp.IFTPConnectionData`** — FTP connection data interface

## Servlet Layer Restructuring

The servlet compatibility layer has been reorganised to reflect the javax → jakarta migration:

| Package | Lucee 6 | Lucee 7 |
| --------- | --------- | --------- |
| `lucee.loader.servlet.*` | Native javax servlets | Deprecated javax wrappers |
| `lucee.loader.servlet.jakarta.*` | Javax→Jakarta adapters | **Native** jakarta servlets + filters |
| `lucee.loader.servlet.javax.*` | *(did not exist)* | Jakarta→Javax adapters |

New in Lucee 7's `jakarta` package:

- `LuceeFilter` — servlet filter support
- `LuceeServletContextListener` — servlet context lifecycle listener

See [[javax-jakarta]] for servlet configuration details.

## Removed

- **`lucee.runtime.util.Pack200Util`** — removed (Pack200 was dropped from Java 11+)
