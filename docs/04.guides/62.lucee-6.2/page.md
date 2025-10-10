---
title: Lucee 6.2 new features
menuTitle: Lucee 6.2
id: lucee_6_2_overview
---

# Lucee 6.2 - Performance

Lucee 6.2 is a significant release focused on performance improvements, Jakarta Servlet support, and introducing experimental AI and Java integration features that became production-ready in Lucee 7.

## What You Need to Know

- **Up to 50% faster** - Major performance improvements over Lucee 5.4
- **Jakarta Servlet support** - Runs on Tomcat 10+ (still javax-based)
- **Experimental AI** - AI integration functions (production-ready in 7.0)
- **Experimental Java** - Enhanced Java interop (production-ready in 7.0)
- **Single Mode available** - Optional in 6.2, mandatory in 7.0
- **Java 8 dropped** - Java 11+ required, Java 21 recommended
- **PreciseMath off by default** - For better performance

## Performance Improvements

Lucee 6.2 delivers substantial performance gains:

- **Up to 50% faster** than Lucee 5.4 for many operations
- **Lower memory usage** - PreciseMath off by default reduces overhead
- **Faster startup** - Optimized initialization
- **Better throughput** - Query execution and general CFML processing

## New Features in Lucee 6.2

For a complete list of changes, see the [[changelog]].

### New Functions

**Session Management:**

- [[function-sessionExists]] - Check if a session exists without creating one
- [[function-sessionRotate]] - Enhanced session rotation with better security

**System & Environment:**

- [[function-GetSystemPropOrEnvVar]] - Get system property or environment variable
- [[function-getTempDirectory]] - Enhanced with optional `prefix` argument for unique temp directories

**Security:**

- [[function-CSRFVerifyToken]] - Enhanced with optional `remove` argument

### Java Integration using Maven

Direct Maven support for Java library management:

- Define Maven dependencies in `Application.cfc` via `this.javaSettings`
- Automatic dependency resolution and loading
- Simplifies Java library integration
- Works with `.CFConfig.json` for global dependencies

See [[maven]] and [[java-settings]] for complete details.

**Example - Markdown Parsing with CommonMark:**

```cfml
component
	javaSettings='{
		"maven": [
			"org.commonmark:commonmark:0.24.0",
			"org.commonmark:commonmark-ext-gfm-tables:0.24.0"
		]
	}'
{
	import org.commonmark.parser.Parser;
	import org.commonmark.renderer.html.HtmlRenderer;
	import org.commonmark.ext.gfm.tables.TablesExtension;

	function render( string markdown ){
		var extensions = [ TablesExtension::create() ];
		var parser = Parser::builder().extensions( extensions ).build();
		var document = parser.parse( arguments.markdown );
		var renderer = HtmlRenderer::builder().extensions( extensions ).build();
		return renderer.render( document );
	}
}
```

Maven automatically downloads the libraries and all their dependencies - no manual JAR management!

### Quartz Scheduler Extension

Industry-standard task scheduling using Quartz:

- Multiple job types (URL, paths, components)
- Clustering support (database or Redis)
- Flexible cron expressions
- Event listeners for job monitoring
- 100% CFML implementation

See [[scheduler-quartz]] for details.

## Experimental Features (Production Ready in 7.0)

These features were introduced as experimental ( subject to change ) in Lucee 6.2 and became stable in Lucee 7.0.

### AI Support (Experimental)

Early AI integration functions:

- [[function-CreateAISession]] - Create AI sessions
- [[function-InquiryAISession]] - Query AI
- [[function-SerializeAISession]] - Save conversation state
- [[function-LoadAISession]] - Restore conversation state
- [[function-AIHas]] - Check AI provider availability
- [[function-AIGetMetadata]] - Get provider info

See [[ai]] for documentation.

**Status:** Experimental in 6.2, production-ready in 7.0

### Enhanced Java Support (Experimental)

Improved Java interoperability:

- Better class loading
- Maven integration improvements
- Enhanced Java object interaction
- Python via Java integration demonstrated

**Status:** Experimental in 6.2, production-ready in 7.0

See Java recipes under [[java-class-interaction]] for details.

## Jakarta Servlet Support

Lucee 6.2 adds support for Jakarta-based servlet engines (Tomcat 10+, Jetty 12, Undertow 2.3+) while still being javax-based.

**What this means:**

- Can run on Tomcat 10+ or Tomcat 9
- Still uses javax namespace internally
- Requires additional javax JARs when deploying to Jakarta servlet engines
- Official installers bundle Tomcat 10+ with required javax libraries

**Manual deployment to Jakarta engines requires:**

- [javax.servlet-api-4.0.1.jar](https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar)
- [javax.servlet.jsp-api-2.3.3.jar](https://repo1.maven.org/maven2/javax/servlet/jsp/javax.servlet.jsp-api/2.3.3/javax.servlet.jsp-api-2.3.3.jar)
- [javax.el-api-3.0.0.jar](https://repo1.maven.org/maven2/javax/el/javax.el-api/3.0.0/javax.el-api-3.0.0.jar)

See [LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

## Single Mode Available

Single Mode (introduced in Lucee 6.0) is available as an option in 6.2:

- Simplifies configuration management
- One server configuration instead of web contexts
- **Optional in 6.2**
- **Mandatory in 7.0**

See [[single-vs-multi-mode]] for complete details.

## Java Version Support

- **Recommended:** Java 21 (LTS)
- **Supported:** Java 11, Java 23
- **Avoid:** Java 24-ea (date handling issues)
- **Dropped:** Java 8 (no longer supported)

## Key Changes

### PreciseMath Off by Default

For performance reasons, `preciseMath` is now off by default:

- Uses `Double` instead of `BigDecimal`
- Significantly faster number operations
- Lower memory usage
- **Recommendation:** Enable dynamically only when needed

```cfml
// Enable only when precision matters
application action="update" preciseMath="true";
result = 0.1 + 0.2; // Will be exactly 0.3
application action="update" preciseMath="false";
```

See [[mathematical-precision]] for details.

### Default Application Log Level

Default application log level changed to `ERROR` to reduce log noise.

[LDEV-5366](https://luceeserver.atlassian.net/browse/LDEV-5366)

### Platform Support

New installers for:

- Linux Arm64/aarch64
- AlmaLinux/RedHat updates
- Tomcat 11

## Breaking Changes

See [[breaking-changes-6-1-to-6-2]] for complete list of breaking changes when upgrading from Lucee 6.1.

### Key Breaking Changes:

1. **Java 8 dropped** - Java 11+ required
2. **PreciseMath default changed** - Now off by default
3. **Cookie expires now GMT** - Was UTC previously
4. **pagePoolClear() memory issues** - Use [[function-inspectTemplates]] instead
5. **Performance improvements** - May expose race conditions in application code

## Upgrade Notes

### Admin Upgrade Limitation (6.2.2+)

Due to upstream Maven changes, latest 6.2.2+ updates may not appear in the Lucee Admin.

**Workaround:** [Manual update process](https://dev.lucee.org/t/lucee-6-2-7-0-latest-upgrades-not-showing-in-the-admin-workaround/15299)

### Upgrading from 5.4

- Performance improvements are substantial (up to 50% faster)
- Test thoroughly - faster execution may expose race conditions
- Review [[breaking-changes-6-1-to-6-2]] carefully
- Consider enabling Single Mode

## Migration Path

It's highly recommended to do a fresh install
[Tomcat 9 to Tomcat 11 Upgrade Guide](https://dev.lucee.org/t/lucee-5-4-to-6-2-upgrade-guide-tomcat-9-to-tomcat-11/14854)

**From Lucee 5.4 → 6.2:**

Review the breaking changes

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]

## Resources

- [[breaking-changes-6-1-to-6-2]] - Complete breaking changes list
- [[single-vs-multi-mode]] - Understanding Single Mode
- [[mathematical-precision]] - PreciseMath details
- [[ai]] - AI integration guide (experimental in 6.2)
- [[java-class-interaction]] - Java interop (experimental in 6.2)
- [[changelog]] - Complete changelog
- [Lucee 6.2 Forum Posts](https://dev.lucee.org/tag/lucee-62) - Release announcements
- [Lucee 6.2 Changelog](https://download.lucee.org/changelog/?version=6.2) - Detailed changes

## Community and Support

For questions, issues, or feature requests:

- [Lucee Dev Forum](https://dev.lucee.org/)
- [[troubleshooting]]

## Looking Forward

Many experimental features in Lucee 6.2 became production-ready in Lucee 7.0:

- AI integration (experimental → stable)
- Java enhancements (experimental → stable)
- Single Mode (optional → mandatory)
- Jakarta EE (supported → required)

See [[lucee_7_overview]] for what's new in Lucee 7.
