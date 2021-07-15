---
title: Upgrading from Railo
id: lucee-5-updating-railo
---

# Upgrade from Railo #

* Stop the servlet engine
* Go to the Lucee website to the [download page](https://lucee.org/downloads.html), download "Custom/JARs for Lucee 5" and unzip the downloaded zip file somewhere on your system.
* If the folder "{servlet-engine}/lib/ext" exists: remove all jars, but do not remove the directory "railo-server"/"lucee-server" if that directory is present there (which is the case with default installations).
* If the folder "{servlet-engine}/lib/ext" doesn't exist yet: Create the folder "{servlet-engine}/lib/ext"
* Copy **lucee.jar** and **org-apache-felix-main-x-x-x.jar** (x-x-x stands for a specific version) to "{servlet-engine}/lib/ext"
* Remove "-javaagent:.../...-inst.jar" from the startup script.
* Remove "MessageBrokerServlet" definition with mapping from your web.xml (Tomcat: conf/web.xml, Jetty etc/webdefault.xml)
* Add Lucee Servlet to /conf/web.xml (pay attention to the load-on-startup values for your servlets)

```xml

 	<servlet>
 		<servlet-name>LuceeServlet</servlet-name>
 		<servlet-class>lucee.loader.servlet.LuceeServlet</servlet-class>
 		<load-on-startup>2</load-on-startup>
 	</servlet>
 	<servlet-mapping>
 		<servlet-name>LuceeServlet</servlet-name>
 		<url-pattern>*.lucee</url-pattern>
 		<url-pattern>/index.lucee/*</url-pattern>
 	</servlet-mapping>
```

* Add the following code to catalina.properties (Tomcat: conf/catalina.properties) at the and of **common.loader=...**

```
,"${catalina.base}/lib/ext","${catalina.base}/lib/ext/*.jar","${catalina.home}/lib/ext","${catalina.home}/lib/ext/*.jar"
```

* If you have not defined a "railo-server-directory"/"lucee-server-directory" in your servlet specification, add the rest of the jars you have downloaded to "{servlet-engine}/lucee-server/bundles/" (you will need to create these folders). If you have defined a "railo-server-directory"/"lucee-server-directory" with your servlet specification copy the jars to "{lucee-server-directory-path}/lucee-server/bundles"
* Please check the servlet definition for the CFMLServlet: The value for "<load-on-startup>" should be 1, otherwise (at this stage) the params "lucee-server-directory" and "lucee-web-directory" are ignored!
* Start the servlet engine

**Important information**

With Lucee 5 the JARs used by Lucee (except lucee.jar and org-apache-felix-main-x-x-x.jar) are handled by Lucee and no longer by the servlet engine. It is therefore important that the servlet engine does not load the jars you added. Therefore they should not be in the servlet engines classpath, for example not inside the lib folder.

**Sample Lucee Servlet Definition in web.xml**

```xml

    <!-- ===================================================================== -->
    <!-- Lucee CFML Servlet - this is the main Lucee servlet                   -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <servlet>
        <servlet-name>CFMLServlet</servlet-name>
        <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
        <init-param>
            <param-name>lucee-server-directory</param-name>
            <param-value>D:/ApacheTomcat/</param-value>
            <description>Directory where Lucee server directory is stored</description>
        </init-param>
        <init-param>
            <param-name>lucee-web-directory</param-name>
            <param-value>D:/ApacheTomcat/lucee-web/{web-context-label}/</param-value>
            <description>Lucee Web Directory</description>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>CFMLServlet</servlet-name>
        <url-pattern>*.cfc</url-pattern>
        <url-pattern>*.cfm</url-pattern>
        <url-pattern>*.cfml</url-pattern>
        <url-pattern>/index.cfc/*</url-pattern>
        <url-pattern>/index.cfm/*</url-pattern>
        <url-pattern>/index.cfml/*</url-pattern>
    </servlet-mapping>

    <servlet>
        <servlet-name>LuceeServlet</servlet-name>
        <servlet-class>lucee.loader.servlet.LuceeServlet</servlet-class>
        <load-on-startup>2</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>LuceeServlet</servlet-name>
        <url-pattern>*.lucee</url-pattern>
        <url-pattern>/index.lucee/*</url-pattern>
    </servlet-mapping>
    <!-- ===================================================================== -->
    <!-- Lucee REST Servlet - handles Lucee's RESTful web services             -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <servlet>
        <servlet-name>RESTServlet</servlet-name>
        <servlet-class>lucee.loader.servlet.RestServlet</servlet-class>
        <load-on-startup>3</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>RESTServlet</servlet-name>
        <url-pattern>/rest/*</url-pattern>
    </servlet-mapping>
```
