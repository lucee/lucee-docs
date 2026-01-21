<!--
{
  "title": "Servlet Configuration",
  "id": "servlet-configuration",
  "description": "How to deploy and configure Lucee on servlet containers",
  "keywords": [
    "java",
    "javax",
    "jakarta",
    "servlet",
    "tomcat",
    "jetty",
    "undertow",
    "war",
    "docker"
  ],
  "categories": [
    "java",
    "server"
  ],
  "related": [
	"deploying-lucee-server-apps",
	"breaking-changes-6-2-to-7-0",
	"breaking-changes-6-1-to-6-2",
  "lucee-lockdown-guide"
  ]
}
-->

# Servlet Configuration

Lucee runs as a Java servlet application inside a servlet container (also called a servlet engine). 

This guide covers how Lucee integrates with servlet containers and how to configure custom deployments.

## Quick Start

For most users, the easiest way to get started is:

- **[Lucee Installer](https://download.lucee.org)** - Bundles Tomcat, ready to run
- **[Lucee Express](https://download.lucee.org)** - Standalone zip with Tomcat, no install required
- **[Lucee Docker Images](https://hub.docker.com/r/lucee/lucee)** - Pre-configured Tomcat containers

This guide is for developers who need to:

- Deploy Lucee to an existing servlet container
- Build custom WAR files
- Integrate Lucee with non-Tomcat servlet engines
- Understand how Lucee's servlet configuration works

## What is a Servlet Container?

A servlet container is a Java application server that handles HTTP requests and dispatches them to servlet classes.

**Apache Tomcat** is Lucee's default and recommended servlet container - it's what we bundle with our installers, Express downloads, and Docker images.

Other servlet containers include:

- **Eclipse Jetty** - Lightweight, embeddable servlet container
- **Undertow** - High-performance servlet container (used by WildFly/JBoss)
- **WildFly** - Full Jakarta EE application server
- **Payara** - Enterprise Jakarta EE application server

Lucee provides servlet classes that process CFML requests:

- **CFMLServlet** - Handles `.cfm`, `.cfs`, `.cfc`, and `.cfml` files
- **RESTServlet** - Handles REST API requests at `/rest/*`

## Version Compatibility Matrix

The Java servlet API underwent a major namespace change from `javax.servlet` to `jakarta.servlet` starting with Jakarta EE 9. 

This affects which Lucee servlet classes you need to use.

| Lucee Version | Servlet API | Servlet Class | Compatible Containers |
|---------------|-------------|---------------|----------------------|
| 5.x | javax (Servlet 4.0) | `lucee.loader.servlet.CFMLServlet` | Tomcat 9, Jetty 9/10, Undertow 2.x |
| 6.2 | javax + jakarta | `lucee.loader.servlet.CFMLServlet` (javax) or `lucee.loader.servlet.jakarta.CFMLServlet` (jakarta) | Tomcat 9-11, Jetty 9-12, Undertow 2.x-3.x |
| 7.x | jakarta native | `lucee.loader.servlet.jakarta.CFMLServlet`| Tomcat 10+, Jetty 11+, Undertow 3.x, WildFly 27+, Payara 6+ |

**Note:** Lucee 6.2 can run on Jakarta EE containers (Tomcat 10+, Jetty 11+) using the jakarta servlet class, but you must include the javax servlet JARs in your deployment since Lucee 6.x internally still uses the javax API.

The required javax JARs (included automatically by the Lucee Installer/Express/Docker for Tomcat 10+):

- [javax.servlet-api-4.0.1.jar](https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar)
- [javax.servlet.jsp-api-2.3.3.jar](https://repo1.maven.org/maven2/javax/servlet/jsp/javax.servlet.jsp-api/2.3.3/javax.servlet.jsp-api-2.3.3.jar)
- [javax.el-api-3.0.0.jar](https://repo1.maven.org/maven2/javax/el/javax.el-api/3.0.0/javax.el-api-3.0.0.jar)

## WAR Deployment

A WAR (Web Application Archive) file is the standard way to deploy Java web applications. Lucee provides pre-built WAR files at [download.lucee.org](https://download.lucee.org), or you can build your own.

This section is for developers who want to build custom WAR files or understand the WAR structure. 

For most deployments, simply use the Lucee Installer, Docker or Express download instead.

### WAR File Structure

```
lucee.war/
+-- WEB-INF/
|   +-- web.xml              # Servlet configuration
|   +-- lib/
|   |   +-- lucee.jar        # Lucee loader JAR
|   +-- lucee-server/        # (optional) pre-configured server context
|       +-- context/
|           +-- deploy/      # Extensions to auto-deploy (.lex files)
+-- index.cfm                # Default welcome file
+-- Application.cfc          # (optional) Application configuration
```

### Minimal web.xml (Java EE / javax)

Use this configuration for Lucee 5.x/6.x on Tomcat 9, Jetty 9/10, or other Java EE containers:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
  metadata-complete="true"
  version="4.0">

  <request-character-encoding>UTF-8</request-character-encoding>
  <response-character-encoding>UTF-8</response-character-encoding>

  <!-- Lucee CFML Servlet -->
  <servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
  </servlet>

  <!-- Lucee REST Servlet -->
  <servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.RestServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
  </servlet>

  <!-- CFML URL Mappings -->
  <servlet-mapping>
    <servlet-name>CFMLServlet</servlet-name>
    <url-pattern>*.cfm</url-pattern>
    <url-pattern>*.cfs</url-pattern>
    <url-pattern>*.cfc</url-pattern>
    <url-pattern>*.cfml</url-pattern>
    <url-pattern>/index.cfm/*</url-pattern>
    <url-pattern>/index.cfc/*</url-pattern>
    <url-pattern>/index.cfml/*</url-pattern>
  </servlet-mapping>

  <!-- REST URL Mapping -->
  <servlet-mapping>
    <servlet-name>RESTServlet</servlet-name>
    <url-pattern>/rest/*</url-pattern>
  </servlet-mapping>

  <welcome-file-list>
    <welcome-file>index.cfm</welcome-file>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
  </welcome-file-list>
</web-app>
```

### Minimal web.xml (Jakarta EE)

Use this configuration for Lucee 6.2/7.x on Tomcat 10+, Jetty 11+, or other Jakarta EE containers:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
                      https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
  metadata-complete="true"
  version="6.0">

  <request-character-encoding>UTF-8</request-character-encoding>
  <response-character-encoding>UTF-8</response-character-encoding>

  <!-- Lucee CFML Servlet (Jakarta) -->
  <servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.CFMLServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
  </servlet>

  <!-- Lucee REST Servlet (Jakarta) -->
  <servlet>
    <servlet-name>RESTServlet</servlet-name>
    <servlet-class>lucee.loader.servlet.jakarta.RestServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
  </servlet>

  <!-- CFML URL Mappings -->
  <servlet-mapping>
    <servlet-name>CFMLServlet</servlet-name>
    <url-pattern>*.cfm</url-pattern>
    <url-pattern>*.cfc</url-pattern>
    <url-pattern>*.cfml</url-pattern>
    <url-pattern>/index.cfm/*</url-pattern>
    <url-pattern>/index.cfc/*</url-pattern>
    <url-pattern>/index.cfml/*</url-pattern>
  </servlet-mapping>

  <!-- REST URL Mapping -->
  <servlet-mapping>
    <servlet-name>RESTServlet</servlet-name>
    <url-pattern>/rest/*</url-pattern>
  </servlet-mapping>

  <welcome-file-list>
    <welcome-file>index.cfm</welcome-file>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
  </welcome-file-list>
</web-app>
```

For Tomcat 11, use `web-app_6_1.xsd` instead of `web-app_6_0.xsd`.

### Servlet Init Parameters

You can customize Lucee's configuration directories using init parameters:

```xml
<servlet>
  <servlet-name>CFMLServlet</servlet-name>
  <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>

  <!-- Custom server configuration directory -->
  <init-param>
    <param-name>lucee-server-directory</param-name>
    <param-value>/var/lucee/config/server/</param-value>
  </init-param>

  <!-- Custom web context directory (supports {web-context-label} placeholder) -->
  <init-param>
    <param-name>lucee-web-directory</param-name>
    <param-value>/var/lucee/config/web/{web-context-label}/</param-value>
  </init-param>

  <load-on-startup>1</load-on-startup>
</servlet>
```

## Container-Specific Deployment

### Apache Tomcat (Recommended)

Tomcat is Lucee's default servlet container. 

The Lucee Installer, Docker images and Express downloads all include a pre-configured Tomcat instance.

**Using the Lucee Installer/Express:**

The bundled Tomcat is already configured with Lucee servlets. Just add your CFML files to the `webapps/ROOT/` directory.

**Adding Lucee to an existing Tomcat:**

1. Download `lucee.jar` from [download.lucee.org](https://download.lucee.org)
2. Copy `lucee.jar` to `$CATALINA_HOME/lib/`
3. Add Lucee servlet definitions to `$CATALINA_HOME/conf/web.xml` (see examples above)
4. Restart Tomcat

**WAR Deployment:**

1. Download or build a Lucee WAR file
2. Copy the WAR to `$CATALINA_HOME/webapps/`
3. Tomcat will automatically deploy the application

**Deploy as ROOT application:**

1. Remove or rename the existing `webapps/ROOT` directory
2. Copy your WAR to `webapps/ROOT.war` or extract it to `webapps/ROOT/`

**Version compatibility:**

- Tomcat 9.0 - Use javax servlet classes
- Tomcat 10.1 - Use jakarta servlet classes (web-app 6.0)
- Tomcat 11.0 - Use jakarta servlet classes (web-app 6.1)

### Other Servlet Containers

While Tomcat is recommended, Lucee works with any compliant servlet container.

#### Eclipse Jetty

1. Copy your WAR file to `$JETTY_HOME/webapps/`
2. Start Jetty

Version compatibility:

- Jetty 9.x/10.x - Use javax servlet classes
- Jetty 11.x/12.x - Use jakarta servlet classes

#### Undertow

Undertow is commonly used programmatically. Here's a simplified example (imports and classpath setup omitted):

```java
DeploymentInfo servletBuilder = Servlets.deployment()
    .setClassLoader(MyApp.class.getClassLoader())
    .setContextPath("/")
    .setDeploymentName("lucee.war")
    .addServlets(
        Servlets.servlet("CFMLServlet", CFMLServlet.class)
            .addMapping("*.cfm")
            .addMapping("*.cfc")
            .setLoadOnStartup(1)
    );

DeploymentManager manager = Servlets.defaultContainer()
    .addDeployment(servletBuilder);
manager.deploy();

Undertow server = Undertow.builder()
    .addHttpListener(8080, "0.0.0.0")
    .setHandler(manager.start())
    .build();
server.start();
```

**Version compatibility:**

- Undertow 2.x - Use javax servlet classes
- Undertow 3.x - Use jakarta servlet classes

#### Application Servers (WildFly, Payara)

For full Jakarta EE application servers, deploy your WAR through the admin console or by copying to the deployments directory.

**WildFly:**

- WildFly 26 and earlier - Java EE (javax)
- WildFly 27+ - Jakarta EE (jakarta)

**Payara:**

- Payara 5 - Java EE (javax)
- Payara 6+ - Jakarta EE (jakarta)

## Docker Deployment

The official Lucee Docker images provide a pre-configured Tomcat environment.

**Basic usage:**

```bash
docker run -d -p 8888:8888 lucee/lucee:6.2
```

**With custom web root:**

```bash
docker run -d -p 8888:8888 -v /path/to/webroot:/var/www lucee/lucee:6.2
```

**Key environment variables:**

| Variable | Description | Default |
|----------|-------------|---------|
| `LUCEE_JAVA_OPTS` | JVM memory settings | `-Xms64m -Xmx512m` |
| `LUCEE_ADMIN_PASSWORD` | Lucee admin password | (none) |
| `LUCEE_ENABLE_WARMUP` | Pre-warm Lucee during build | `false` |

**Image variants:**

- `lucee/lucee:6.2` - Lucee 6.2 with Tomcat
- `lucee/lucee:6.2-light` - Lucee 6.2 without bundled extensions
- `lucee/lucee:6.2-zero` - Lucee 6.2 without admin or bundled extensions
- `lucee/lucee:7.0` - Lucee 7.0 with Tomcat 11 (Jakarta EE)

The Docker images automatically use the correct servlet classes based on the Lucee version.

With Lucee light, the Admin is on disk, but requires the admin extension, which simply adds a mapping making the Admin available. 

Lucee Zero does not include the Admin.

## Standalone/Embedded Deployment

For custom standalone deployments, you can integrate Lucee with a fresh Tomcat installation. However, for most use cases, the **Lucee Express** download is simpler - it's a pre-configured Tomcat with Lucee ready to run.

**Manual setup (if you need full control):**

1. Download Apache Tomcat from [tomcat.apache.org](https://tomcat.apache.org)
2. Download `lucee.jar` from [download.lucee.org](https://download.lucee.org)
3. Copy `lucee.jar` to `$CATALINA_HOME/lib/`
4. Edit `$CATALINA_HOME/conf/web.xml` to add Lucee servlet definitions
5. Configure your application in `$CATALINA_HOME/webapps/ROOT/`
6. Start Tomcat with `bin/startup.sh` (Linux/Mac) or `bin/startup.bat` (Windows)

Express includes the original `web.xml` and `server.xml` in the `/conf` dir, so you can do a diff to see the changes made.

## Basic Tuning

### UTF-8 Character Encoding

Always set UTF-8 encoding in your web.xml:

```xml
<request-character-encoding>UTF-8</request-character-encoding>
<response-character-encoding>UTF-8</response-character-encoding>
```

### Disable JAR Scanning

JAR scanning at startup can be slow. Disable it in your context configuration.

**Tomcat context.xml:**

```xml
<Context>
  <JarScanner scanClassPath="false"/>
</Context>
```

### Disable Annotation Scanning

The `metadata-complete="true"` attribute in web.xml tells the container not to scan for servlet annotations, improving startup time:

```xml
<web-app ... metadata-complete="true">
```

### Load on Startup

Always use `<load-on-startup>` to ensure Lucee initializes when the server starts, not on the first request:

```xml
<servlet>
  <servlet-name>CFMLServlet</servlet-name>
  <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
  <load-on-startup>1</load-on-startup>
</servlet>
```

## Reverse Proxy

Lucee commonly runs behind a reverse proxy such as Apache httpd or nginx. This allows:

- SSL termination at the proxy
- Load balancing across multiple Lucee instances
- Serving static files directly from the proxy
- URL rewriting

For Apache httpd integration, see the [mod_cfml](https://viviotech.github.io/mod_cfml/) project which automatically creates Tomcat contexts based on incoming hostnames.

The current versions are now maintained at [lucee/mod_cfml](https://github.com/lucee/mod_cfml)

For AJP (Apache JServ Protocol) connections, configure the AJP connector in Tomcat's `server.xml`:

```xml
<Connector protocol="AJP/1.3"
           port="8009"
           secretRequired="true"
           secret="your-secret-key"
           redirectPort="8443" />
```
