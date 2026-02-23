<!--
{
  "title": "javax vs jakarta Servlet Compatibility",
  "id": "javax-jakarta",
  "since": "6.1",
  "categories": ["server"],
  "description": "How Lucee handles javax and jakarta servlet APIs across versions and servlet engines",
  "keywords": [
    "javax",
    "jakarta",
    "servlet",
    "Tomcat",
    "Jetty",
    "web.xml",
    "CFMLServlet",
    "RestServlet",
    "migration"
  ]
}
-->

# javax vs jakarta Servlet Compatibility

Lucee supports both `javax.servlet` and `jakarta.servlet` APIs, allowing it to run on older servlet engines (e.g., Tomcat 9, Jetty 10) as well as modern Jakarta-based engines (e.g., Tomcat 11, Jetty 12).

## Overview

| Lucee Version | Native API | Emulated API |
|---------------|-----------|--------------|
| **6.1 / 6.2** | `javax.servlet` | `jakarta.servlet` |
| **7.0+** | `jakarta.servlet` | `javax.servlet` |

> **Recommendation**: Always prefer running Lucee with its **native** servlet API. Emulation adds an unnecessary layer and should only be used when you cannot match your servlet engine to Lucee's native API. For best performance and reliability, pair Lucee 6.x with a javax engine and Lucee 7.x with a Jakarta engine.

### Classpath Requirement

A `javax`-based server does not provide `jakarta` interfaces and vice versa. When using emulation, you must add the missing interfaces to the server's classpath:

- **Lucee 6.2 on a Jakarta engine** (e.g., Tomcat 11): add [`javax.servlet-api`](https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api) to the classpath
- **Lucee 7.0 on a javax engine** (e.g., Tomcat 9): add [`jakarta.servlet-api`](https://mvnrepository.com/artifact/jakarta.servlet/jakarta.servlet-api) to the classpath

## Servlet Classes

### Lucee 6.1 / 6.2

| Servlet Class | API | Type |
|---------------|-----|------|
| `lucee.loader.servlet.CFMLServlet` | javax | **Native** |
| `lucee.loader.servlet.jakarta.CFMLServlet` | jakarta | Emulated |
| `lucee.loader.servlet.RestServlet` | javax | **Native** |
| `lucee.loader.servlet.jakarta.RestServlet` | jakarta | Emulated |

### Lucee 7.0+

| Servlet Class | API | Type |
|---------------|-----|------|
| `lucee.loader.servlet.jakarta.CFMLServlet` | jakarta | **Native** |
| `lucee.loader.servlet.jakarta.RestServlet` | jakarta | **Native** |
| `lucee.loader.servlet.javax.CFMLServlet` | javax | Emulated |
| `lucee.loader.servlet.javax.RestServlet` | javax | Emulated |
| `lucee.loader.servlet.CFMLServlet` ⚠️ | javax | Emulated (deprecated) |
| `lucee.loader.servlet.RestServlet` ⚠️ | javax | Emulated (deprecated) |

> **Deprecation Notice**: `lucee.loader.servlet.CFMLServlet` and `lucee.loader.servlet.RestServlet` (without namespace qualifier) are deprecated in Lucee 7. They currently behave as javax-emulated servlets but will be removed or changed to Jakarta-native in **Lucee 8**. Use the explicit `javax` or `jakarta` namespaced variants instead.

## Configuration

### web.xml Examples

#### Lucee 6.2 on a javax Servlet Engine (e.g., Tomcat 9) — Native

```xml
<servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
</servlet>
<servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.RestServlet</servlet-class>
</servlet>
```

#### Lucee 6.2 on a Jakarta Servlet Engine (e.g., Tomcat 11) — Emulated

```xml
<servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.CFMLServlet</servlet-class>
</servlet>
<servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.RestServlet</servlet-class>
</servlet>
```

#### Lucee 7.0 on a Jakarta Servlet Engine (e.g., Tomcat 11) — Native

```xml
<servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.CFMLServlet</servlet-class>
</servlet>
<servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.RestServlet</servlet-class>
</servlet>
```

#### Lucee 7.0 on a javax Servlet Engine (e.g., Tomcat 9) — Emulated

```xml
<servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.javax.CFMLServlet</servlet-class>
</servlet>
<servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.javax.RestServlet</servlet-class>
</servlet>
```
