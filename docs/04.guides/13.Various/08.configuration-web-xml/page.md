---
title: Configuration:web.xml
id: configuration-web-xml
---

## web.xml ##

Lucee is a Servlet, and therefore it runs inside a Servlet Container, e.g. Jetty, Tomcat, etc. (with the exception of the CLI). The servlet container abides by the Java Servlet Specification, and thus some of the configuration settings are stored in a file named web.xml

Most Servlet Containers use two configuration files:

1. A Global (Servlet-Container-wide) web.xml file. For example, in Jetty that is the {Jetty}/etc/webdefault.xml and in Tomcat it is at {Tomcat}/conf/web.xml

1. A Local (Context-specific) web.xml which is located at {Your-Website}/WEB-INF/web.xml

When the Servlet Container starts up, the Global configuration file is read, and if the Local web.xml exists, it is read as well and overrides the Global settings.

Below are the settings for the servlets that ship with Lucee. Some of the values are commented out (using standard XML comments), and can be un-commented and modified as needed. The Servlets usually have good default values so if you don't need to change them they can be used without any init-param(s).

The Lucee CFML Servlet is the main servlet for Lucee and is always required. The other servlets are optional, and can be disabled (by either commenting out, or completely removing the section) if you are not using the services that they provide.

```lucee
<!-- ===================================================================== -->
<!-- Lucee CFML Servlet - this is the main Lucee servlet                   -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<servlet id="Lucee">
  <description>Lucee CFML Engine</description>
  <servlet-name>CFMLServlet</servlet-name>    
  <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- to specify the location of the Lucee Server config and libraries,   -->
  <!-- uncomment the init-param below.  make sure that the param-value     -->
  <!-- points to a valid folder, and that the process that runs Lucee has  -->
  <!-- write permissions to that folder.  leave commented for defaults.    -->
  <!--
  <init-param>
    <param-name>lucee-server-root</param-name>
    <param-value>/var/Lucee/config/server/</param-value>
    <description>Lucee Server configuration directory (for Server-wide configurations, settings, and libraries)</description>
  </init-param>
  !-->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- to specify the location of the Web Contexts' config and libraries,  -->
  <!-- uncomment the init-param below.  make sure that the param-value     -->
  <!-- points to a valid folder, and that the process that runs Lucee has  -->
  <!-- write permissions to that folder.  the {web-context-label} can be   -->
  <!-- set in Lucee Server Admin homepage.  leave commented for defaults.  -->
  <!--
  <init-param>
    <param-name>lucee-web-directory</param-name>
    <param-value>/var/Lucee/config/web/{web-context-label}/</param-value> 
    <description>Lucee Web Directory (for Website-specific configurations, settings, and libraries)</description>
  </init-param>
  !-->
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
  
  <!-- url-pattern>*.cfm/*</url-pattern !-->
  <!-- url-pattern>*.cfml/*</url-pattern !-->
  <!-- url-pattern>*.cfc/*</url-pattern !-->
  <!-- url-pattern>*.htm</url-pattern !-->
  <!-- url-pattern>*.jsp</url-pattern !-->
</servlet-mapping>
```

**REST Servlet** - for processing RESTful services

If you need to enable REST web services, add the xml snippet below to your Global or Local (see above) web.xml configuration file.

```lucee
<!-- ===================================================================== -->
<!-- Lucee REST Servlet - handles Lucee's RESTful web services             -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<servlet id="RESTServlet">
  <description>Lucee Servlet for RESTful services</description>
  <servlet-name>RESTServlet</servlet-name>    
  <servlet-class>lucee.loader.servlet.RestServlet</servlet-class>
  <load-on-startup>2</load-on-startup>
</servlet>  

<servlet-mapping>
  <servlet-name>RESTServlet</servlet-name>
  <url-pattern>/rest/*</url-pattern>
</servlet-mapping>
```

**MessageBroker Servlet** - Flex Gateway Lucee Servlet for Flex Gateway MessageBrokerServlet MessageBrokerServlet flex.messaging.MessageBrokerServlet

```lucee
<servlet-mapping>
  <servlet-name>MessageBrokerServlet</servlet-name>
  <url-pattern>/flex2gateway/*</url-pattern>
  <url-pattern>/flashservices/gateway/*</url-pattern>
  <url-pattern>/messagebroker/*</url-pattern>
</servlet-mapping>
```

**AMF Servlet** - Flash Gateway

The configuration for the AMF Servlet is not included with the Lucee distributions by default anymore. It is presented here in case you want to use it.

```lucee
<!-- ===================================================================== -->
<!-- Lucee AMF Servlet - Flash Gateway                                     -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<servlet id="AMFServlet">
  <servlet-name>AMFServlet</servlet-name>
  <description>AMF servlet for flash remoting</description>
  <servlet-class>lucee.loader.servlet.AMFServlet</servlet-class>
</servlet>

<servlet-mapping>
  <servlet-name>AMFServlet</servlet-name>
  <url-pattern>/openamf/gateway/*</url-pattern>
</servlet-mapping>
```