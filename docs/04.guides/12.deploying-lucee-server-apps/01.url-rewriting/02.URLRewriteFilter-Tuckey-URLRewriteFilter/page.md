---
title: Installation URLRewriteFilter
id: URLRewriteFilter-Tuckey-URLRewriteFilter
---

'Standard WAR deployment'

* Download the URLRewriteFilter package, and copy the urlrewrite-{version}.jar to {war.dir}/WEB-INF/lib

* Edit the {war.dir}/WEB-INF/web.xml, and add this above the first <servlet> element:

```lucee
<filter>
    <filter-name>UrlRewriteFilter</filter-name>
    <filter-class>org.tuckey.web.filters.urlrewrite.UrlRewriteFilter</filter-class>
        <init-param>
            <param-name>logLevel</param-name>
            <param-value>DEBUG</param-value>
        </init-param>
        <init-param>
            <param-name>confReloadCheckInterval</param-name>
            <param-value>1</param-value>
        </init-param>

        <init-param>
            <param-name>confPath</param-name>
            <param-value>/WEB-INF/urlrewrite.xml</param-value>
        </init-param>
</filter>
<filter-mapping>
    <filter-name>UrlRewriteFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

if you need to the conf file path can be changed, you can change the confPath init param, it is specified as a path relative to the root of your context

```lucee
(default /WEB-INF/urlrewrite.xml)
```

* start your appserver

* add your own configuration to the {war.dir}/WEB-INF/urlrewrite.xml that was created. The <init-param> elements enable debug output and reloads the urlrewrite.xml file once a second.

* You can visit 127.0.0.1:8080/rewrite-status (or whatever the address of your local webapp and context) to see output (note: this page is only viewable from localhost).

* when you are satisfied with your rewrites, change the urlrewrite init-param DEBUG option to WARN, and change the confReloadCheckInterval to -1.

'''Lucee Express Deployment (Jetty)'''

* Copy the urlrewritefilter.jar into the {lucee-dir}/lib/ext/ folder

* Edit the ./etc/webdefault.xml file, and add the following right under the </description> element at the top of the file:

```lucee
<filter>
	<filter-name>UrlRewriteFilter</filter-name>
	<filter-class>org.tuckey.web.filters.urlrewrite.UrlRewriteFilter</filter-class>

	<init-param>
	   <param-name>logLevel</param-name>
	   <param-value>DEBUG</param-value>
	</init-param>

	<init-param>
	   <param-name>confReloadCheckInterval</param-name>
	   <param-value>0</param-value>
	</init-param>
</filter>
<filter-mapping>
    <filter-name>UrlRewriteFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

The confReloadCheckInterval init-param sets the amount of seconds the conf file will be checked for reload

```lucee
can be a valid integer (0 denotes check every time,
-1 denotes no reload check, default -1)
```

* copy your urlrewrite.xml file into the ./webroot/WEB-INF folder.

* start the server (./start)

* debug your rewrite rules. The settings above will automatically reload any changes to urlrewrite.xml, and debugging output should be seen in the console with each request, which will help to determine the correct rules.

* when the rules are satisfactory, change the urlrewrite init-param DEBUG option to WARN, and change the confReloadCheckInterval to -1.

* You can also keep the urlrewritefilter.jar in another location, and add it to the classpath when you start the server. This example is a bash script where the urlrewritefilter.jar is located in /opt/jars/lucee:

```lucee
#!/bin/bash
cd $(dirname $0)
java -DSTOP.PORT=8887 -DSTOP.KEY=lucee -jar -Xms256M -Xmx512M lib/start.jar lib=/opt/jars/lucee >> /tmp/lucee-server-`date "+%Y%m%d"` 2>&1
```
