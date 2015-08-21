---
title: Installing and configuring Lucee (JAR files) on Windows
id: running-lucee-installing-and-configuring-lucee-jar-file-on-windows
---

![lucee-logo108x45.png](https://bitbucket.org/repo/rX87Rq/images/1133943380-lucee-logo108x45.png)
## Installation ##

Lucee needs to be downloaded first from this page: [Lucee Downloads](https://bitbucket.org/lucee/lucee/downloads). Choose the *zip file* containing the **JAR files**.

1. Create the folder **C:\Program Files\Lucee**
2. Browse the expanded content in your temporary folder and copy all files to the folder **C:\Program Files\Lucee**
3. Create the folder **D:\Lucee**. This directory will hold the configuration, the log files, some data and the server context.

The jar files require approximately 71MB of diskspace.

Command line:

```
#!dos
md "C:\Program Files\Lucee"
copy D:\temp\*.* "C:\Program Files\Lucee" /Y
md D:\Lucee

```

## Configuration##

We have to take care, that Apache Tomcat is able find the jar files of Lucee. The file **D:\Tomcat\conf\catalina.properties** needs to be edited. Find the line:

```
#!dos

common.loader="${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar"

```
Append the path to Lucee's program directory, which is **C:/Program Files/Lucee/*.jar**. Did you notice the *foward slashes*?

```
#!dos

common.loader="${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar","C:/Program Files/Lucee/*.jar"

```

The next step is to tell Apache Tomcat, that we need a new *welcome file*, which we add in the file **D:\Tomcat\conf\web.xml**. At the end of the file, you will find this list:

```
#!dos

<welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```
**Append** new line containing **index.cfm** as the **last line**:

```
#!dos

<welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
    <welcome-file>index.jsp</welcome-file>
    <welcome-file>index.cfm</welcome-file>
</welcome-file-list>
```

Below this list, new servlets and their mappings must be added:

```
#!dos
<servlet>
    <servlet-name>CFMLServlet</servlet-name>
    <description>CFML runtime Engine</description>
    <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
    <init-param>
       <param-name>lucee-server-directory</param-name>
       <param-value>D:\Lucee</param-value>
       <description>Lucee Server configuration directory (for Server-wide configurations, settings, and libraries)</description>
    </init-param>
    <init-param>
        <param-name>lucee-web-directory</param-name>
        <param-value>{web-root-directory}/WEB-INF/lucee/</param-value>
        <description>Lucee Web Directory (for Website-specific configurations, settings, and libraries)</description>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet>
    <servlet-name>RESTServlet</servlet-name>
    <description>Servlet to access REST service</description>
    <servlet-class>lucee.loader.servlet.RestServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>CFMLServlet</servlet-name>
    <url-pattern>*.cfm</url-pattern>
    <url-pattern>*.cfml</url-pattern>
    <url-pattern>*.cfc</url-pattern>
    <url-pattern>/index.cfm/*</url-pattern>
    <url-pattern>/index.cfc/*</url-pattern>
    <url-pattern>/index.cfml/*</url-pattern>
</servlet-mapping>

<servlet-mapping>
    <servlet-name>RESTServlet</servlet-name>
     <url-pattern>/rest/*</url-pattern>
</servlet-mapping>
```

*Note:* After the last  **</servlet-mapping>**, the file ends by having the closing **</web-app>**

 Finally a Java option needs to be added:

```
#!dos

"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-javaagent:C:\Program Files\Lucee\lucee-inst.jar"
```
