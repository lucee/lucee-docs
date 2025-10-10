---
title: Lucee 7 new features
menuTitle: Lucee 7
id: lucee_7_overview
---

# Lucee 7 - Single Mode & Jakarta Edition

Lucee 7 is a major release that fundamentally changes how Lucee works by moving to **Single Mode only** and migrating to **Jakarta EE**. It also drops Java 8 support, delivers significant performance improvements, and reduces the core distribution size.

## What You Need to Know

- **Single Mode Only**: Multi-mode is gone - this is THE biggest change for users [[single-vs-multi-mode]]
- **New Features**: AST parsing, Secret Provider, enhanced AI & Java support
- **Performance**: Multiple optimizations - faster startup, lower memory usage
- **Jakarta EE**: Full migration from javax to jakarta namespace (requires Tomcat 10.1+)
- **Fresh Install Required**: Cannot upgrade via admin - requires Tomcat 10.1+ and new extensions
- **Smaller & Faster**: 20MB smaller core distribution
- **Security First**: Better defaults, removed insecure legacy features

## New Features in Lucee 7

For a complete list of new and updated tags and functions, checkout our [[changelog]].

### AST (Abstract Syntax Tree) Support

Parse CFML code into an [[ast]] for analysis, tooling, and transformation.

- [[function-astFromPath]] - Parse CFML file to AST
- [[function-astFromString]] - Parse CFML string to AST

### Secret Provider

Store and retrieve secrets securely using the new [[secret-management]] functionality.

- [[function-SecretProviderGet]] - Retrieve secrets from configured providers

This allows integration with secret management systems for credentials, API keys, and sensitive configuration.

### Dynamic Proxy Creation

Components implementing Java interfaces now automatically include all functions and properties in the dynamic proxy. Components can now call [[component-getclass-method]] directly to simplify proxy creation for Java interoperability.

See [[dynamic-proxy-enhancements]] for details and examples.

### Lucene 3 - Vector & Hybrid Search

Major upgrade to [[category-search]] capabilities with modern semantic search features:

**New search modes:**

- **Vector search** - Semantic search using document embeddings
- **Hybrid search** - Combines keyword and vector search for best results
- **Enhanced chunking** - Better passage extraction and relevance

**Perfect for AI/RAG:**

These features enable Retrieval-Augmented Generation (RAG) patterns, allowing AI models to reference your indexed content for more accurate and contextually relevant responses.

See the [[lucene-3-extension]] documentation for complete details.

## Features Now Production Ready

These features were experimental in Lucee 6.2 and are now stable and production-ready in Lucee 7.

### AI Support

AI integration functions are now production-ready:

- [[function-CreateAISession]] - Create a new AI session
- [[function-InquiryAISession]] - Query an AI session
- [[function-SerializeAISession]] - Save AI conversation state
- [[function-LoadAISession]] - Restore AI conversation state
- [[function-AIHas]] - Check if AI provider exists
- [[function-AIGetMetadata]] - Get AI provider metadata

This enables persistent AI conversations across requests and application restarts.

- [[ai-session-serialization]] - AI session serialization
- [[ai-augmentation-lucene]] - AI augmentation with Lucene (RAG)
- [[ai]] - AI integration guide

### Enhanced Java Support

Improved Java interop and integration that was experimental in 6.2 is now stable.

- [[java-class-interaction]] - Seamless integration with Java classes
- [[java-settings]] - Java settings with Maven support
- [[component-getclass-method]] - Dynamic proxy creation for components
- [[java-libraries]] - Loading and using Java libraries
- [[java-scripting-lucee]] - Using Java scripting engines
- [[java-explicit-casting]] - Type casting in Java interop
- [[java-in-functions-and-closures]] - Java usage patterns
- [[convert-a-cfml-func-to-java]] - Converting CFML to Java

## Dark mode Admin

The Admin now supports dark mode, easier on your eyes!

## Performance Improvements

Lucee 7 includes multiple performance optimizations:

**Specific Optimizations:**

- **queryExecute()** - Optimized execution
- **StringBuffer → StringBuilder** - Replaced throughout codebase
- **Lazy CGI Scope Loading** - Only load when accessed
- **Parser Whitespace Handling** - Optimized parsing
- **Application.cfc Single Execution** - Reduced overhead (LDEV-4978)

**Result:** Faster startup, lower memory usage, better runtime performance.

Modern Java versions (Java 21+) further enhance performance with JVM improvements.

## Single Mode Only

**This is the core change in Lucee 7.**

Multi-mode is gone. Lucee 7 only supports Single Mode (introduced in Lucee 6.0). This fundamentally changes how web contexts, configurations, and extensions work.

See [[single-vs-multi-mode]] for complete details on what this means and how to migrate.

**Why this matters more than Jakarta:**

- Affects how you deploy and configure Lucee
- Changes how extensions are managed
- Impacts configuration file locations
- Requires understanding the new architecture

## The Jakarta Switch

Lucee 7 is now based on [Jakarta EE](https://jakarta.ee/) instead of Java EE.

**What this means:**

- **Tomcat 10.1 or higher required** (Tomcat 9 and older no longer supported)
- All `javax.*` imports become `jakarta.*`
- **All extensions must be Jakarta-compatible** (cannot use old javax extensions)
- Fresh install strongly recommended

```cfml
// Old (Lucee 6.2 and earlier)
import javax.servlet.http.HttpServletRequest;

// New (Lucee 7)
import jakarta.servlet.http.HttpServletRequest;
```

### Tomcat Version Requirements

- **Tomcat 10.1+**: Minimum (Jakarta EE support)
- **Tomcat 11**: Requires Java 17+ minimum

## Java Version Requirements

**Java 21: Recommended** (Target version)

- Official target for Lucee 7

**Java 24/25: Better Performance** (supported)

- Released too late in dev cycle to be the official target, will be for 7.1
- Offers better performance

**Java 17-20: Not Recommended**

- Has Unicode/date handling quirks

**Java 11: Minimum**

- Supported but slow
- Will be dropped in future releases
- Not recommended for production

**Java 8: ❌ NO LONGER SUPPORTED**

### ⚠️ Unicode Date Handling Warning

Java versions 17-20 have Unicode-related issues, particularly with date handling. These issues were resolved in Java 21. **Avoid Java 17-20 in production.**

If you're on Java 8, you **must** upgrade to at least Java 11, but **Java 21 is strongly recommended**.

## Extensions & Dependencies

### Extensions Require Jakarta Versions

**Critical:** You cannot use old Tomcat 9/javax-based extensions with Lucee 7. All extensions must be Jakarta-compatible.

When upgrading:

1. Check each extension for Jakarta compatibility
2. Install latest versions from the extension provider
3. Test thoroughly before production deployment

### No Longer Bundled

**EHCache** is no longer included by default (still available as an extension).

- **Old**: 84 MB `lucee.jar`
- **New**: 64 MB `lucee.jar`
- **Reduction**: 20MB (24% smaller)

[LDEV-5267](https://luceeserver.atlassian.net/browse/LDEV-5267)

If you need EHCache, install it as an extension.

### JDBC Driver Updates

- **MySQL**: Updated to latest driver
- **PostgreSQL**: Updated to latest driver

These updates bring bug fixes, security patches, and better performance.

## Breaking Changes

For the complete list, see [[breaking-changes-6-2-to-7-0]].

### High Impact Changes

**1. Single Mode Only**

- Multi-mode removed, no more web contexts or Administrators
- Different configuration architecture
- See [[single-vs-multi-mode]] for migration

**2. Jakarta Namespace**

- `javax.*` → `jakarta.*`
- Requires Tomcat 10.1+
- All extensions must be Jakarta-compatible
- [LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

**3. Java 8 Dropped**

- Minimum: Java 11
- Recommended: Java 21
- Avoid: Java 17-20 (Unicode issues)

**4. Variable Scoping in Functions**

- Tag results like [[tag-query]], [[tag-lock]], [[tag-file]], [[tag-thread]] now properly scope to `local` when used inside functions
- Previously went to `variables` scope (potential race conditions)
- [LDEV-5416](https://luceeserver.atlassian.net/browse/LDEV-5416)

**Before (Lucee 6.2):**

```cfml
function getUsers() {
    cfquery( name="qry", datasource="myDB", sql="SELECT * FROM users" );
    return qry; // qry was in variables scope
}
```

**After (Lucee 7):**

```cfml
function getUsers() {
    cfquery( name="local.qry", datasource="myDB", sql="SELECT * FROM users" );
    return local.qry; // properly scoped!
}
```

**5. Loader API Changed**

- Cannot upgrade via admin from 6.2 to 7.0
- Must manually replace loader JAR
- See upgrade process below

### Medium Impact Changes

**[[tag-cache]] Query String Behavior**

- Now **ignores query strings** by default (matches Adobe ColdFusion)
- Use `useQueryString=true` for old behavior
- [LDEV-5722](https://luceeserver.atlassian.net/browse/LDEV-5722)

### Low Impact Changes

**[[tag-http]] URL Encoding**

- Spaces properly encoded (not double-encoded)
- Remove workarounds for old bug
- [LDEV-3349](https://luceeserver.atlassian.net/browse/LDEV-3349)

**[[tag-mail]] Encoding**

- Quoted-printable encoding (7-bit) now default
- Better HTML email rendering
- [LDEV-4039](https://luceeserver.atlassian.net/browse/LDEV-4039)

**Cookie Storage Removed**

- `loginStorage="cookie"` - ❌ Removed
- `sessionStorage="cookie"` - ❌ Removed
- Insecure and rarely used
- [LDEV-5403](https://luceeserver.atlassian.net/browse/LDEV-5403)

## Security Improvements

### Bytecode Execution Blocked by Default

`LUCEE_COMPILER_BLOCK_BYTECODE` is now enabled by default, preventing CFML files containing Java bytecode from being executed.

This protects against CVE-2024-55354.

[LDEV-5485](https://luceeserver.atlassian.net/browse/LDEV-5485)

### Insecure Features Removed

Cookie-based session storage removed (see Breaking Changes above).

## The Upgrade Process

### Fresh Install Required

**You cannot upgrade via the admin from 6.2 to 7.0.**

Lucee 7 requires:

- Tomcat 10.1+ (for Jakarta)
- All Jakarta-compatible extensions
- Single Mode architecture

**Recommended Approach:**

1. **Set up new Lucee 7 instance**
2. **Install Tomcat 10.1+**
3. **Install Lucee 7** from [download.lucee.org](https://download.lucee.org/)
4. **Install Jakarta-compatible extensions**
5. **Migrate configuration**
6. **Test thoroughly**
7. **Deploy**

### Manual Loader Replacement (Not Recommended)

If you must try to upgrade an existing installation:

1. **Stop Lucee**
2. **Upgrade Tomcat** to 10.1 or higher
3. **Replace the loader JAR**:
   - Find `lucee/lib/lucee-6.2.x.xxx.jar`
   - Replace with `lucee.jar` from [download.lucee.org](https://download.lucee.org/)
4. **Restart Lucee**

If you get a 500 error:

- Stop Lucee
- Delete `.lco` files from `lucee/tomcat/lucee-server/patches`
- Replace the loader JAR properly
- Restart

**Note:** Fresh install is strongly recommended over manual replacement.

### Migration Checklist

1. ✅ **Upgrade Java** to 21 (recommended) or 24/25 (best performance)
2. ✅ **Upgrade Tomcat** to 10.1 or higher
3. ✅ **Review Single Mode architecture** - understand the changes
4. ✅ **Check all extensions** for Jakarta compatibility
5. ✅ **Update javax imports** to jakarta (if you have Java code)
6. ✅ **Fix function-scoped queries** (add `local.` prefix)
7. ✅ **Test cfcache** if you rely on query string behavior
8. ✅ **Check cfhttp** calls if you have URL encoding workarounds
9. ✅ **Review cookie-based session storage** (if you were using it)
10. ✅ **Install EHCache extension** if you need it
11. ✅ **Run your test suite** extensively!

## Resources

- [[breaking-changes-6-2-to-7-0]] - Complete list of breaking changes
- [[single-vs-multi-mode]] - Understanding Single Mode
- [[deploying-lucee-server-apps]] - Deployment guide
- [[config]] - Configuration options
- [[environment-variables-system-properties]] - Environment variable reference
- [[lucee-5-to-6-migration-guide]] - General migration guidance
- [Tomcat 9 to Tomcat 11 Upgrade Guide](https://dev.lucee.org/t/lucee-5-4-to-6-2-upgrade-guide-tomcat-9-to-tomcat-11/14854) - Fresh install process

## Community and Support

For questions, issues, or feature requests:

- [Lucee Dev Forum](https://dev.lucee.org/)
- [[troubleshooting]]