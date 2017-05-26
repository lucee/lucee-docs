---
title: Ubuntu 12.04 Lucee 4 with Tomcat7 multi instance
id: Ubuntu-lucee-with-Tomcat-multi-instance
---

### Introduction ###

This page try to clarify the installation of Lucee 4.0 in Ubuntu 12.04 with Java7, Tomcat 7 with multiple instances and Apache webserver acting as a front-end.

All instances will serve the same website.

I’m really not a Lucee or Java expert, feel free to comment and revise the document.

## Installing basic packages ##

* Java 7
	apt-get install openjdk-7-jre-headless

* Tomcat7, Apache2

	apt-get install tomcat7 tomcat7-admin apache2 libapache2-mod-jk

* Remove Java6 if any:

	apt-get purge openjdk-6-jre-headless icedtea-6-jre-cacao openjdk-6-jre-lib icedtea-6-jre-jamvm

* Install fontconfig and some fonts (cfchart could not find the fonts in my code without it)

	apt-get install fontconfig ttf-mscorefonts-installer

### Lucee 4.0 ###

I will first install the .war and let Tomcat to deploy it. After that, move the lucee lib to a lib directory inside the tomcat7 system installation:

```lucee
wget http://www.getlucee.org/down.cfm\?item=/lucee/remote/download/4.0.2.002/custom/all/lucee-4.0.2.002.war\&thankyou=false -O lucee-4.0.2.002.war
cp  lucee-4.0.2.002.war /var/lib/tomcat7/webapps/lucee.war
service tomcat7 start
mkdir /usr/share/tomcat7/lucee
cp -R /var/lib/tomcat7/webapps/lucee/WEB-INF/lib/* /usr/share/tomcat7/lucee
chown -R tomcat7.tomcat7 /usr/share/tomcat7/lucee
service tomcat7 stop
rm -rf /var/lib/tomcat7/webapps/lucee/  /var/lib/tomcat7/webapps/lucee.war
```

### Tomcat ###

Configure Tomcat to load the new lucee lib directory. Edit the file /etc/tomcat7/catalina.properties and change the line common.loader to:

	common.loader=${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar,/var/lib/tomcat7/common/classes,/var/lib/tomcat7/common/*.jar,${catalina.home}/lucee,${catalina.home}/lucee/*.jar

Edit /etc/tomcat7/web.xml

Add servlet for cfm inside the webapp section:

```lucee
<servlet>
	<servlet-name>GLOBALCFMLServlet</servlet-name>
	<description>CFML runtime Engine</description>
	<servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
	<init-param>
	<param-name>configuration</param-name>
	<param-value>/usr/share/tomcat7/lucee</param-value>
	<description>Configuraton directory</description>
	</init-param>
	<init-param>
	<param-name>lucee-server-root</param-name>
	<param-value>.</param-value>
	<description>directory where lucee root directory is stored</description>
	</init-param>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet>
	<servlet-name>GLOBALAMFServlet</servlet-name>
	<description>AMF Servlet for flash remoting</description>
	<servlet-class>lucee.loader.servlet.AMFServlet</servlet-class>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet>
<servlet-name>GLOBALFileServlet</servlet-name>
	<description>File Servlet for simple files</description>
	<servlet-class>lucee.loader.servlet.FileServlet</servlet-class>
	<load-on-startup>2</load-on-startup>
</servlet>
<servlet-mapping>
	<servlet-name>GLOBALCFMLServlet</servlet-name>
	<url-pattern>*.cfm</url-pattern>
</servlet-mapping>
<servlet-mapping>
	<servlet-name>GLOBALCFMLServlet</servlet-name>
	<url-pattern>*.cfml</url-pattern>
</servlet-mapping>
<servlet-mapping>
	<servlet-name>GLOBALCFMLServlet</servlet-name>
	<url-pattern>*.cfc</url-pattern>
</servlet-mapping>
<servlet-mapping>
	<servlet-name>GLOBALAMFServlet</servlet-name>
	<url-pattern>/openamf/gateway/*</url-pattern>
</servlet-mapping>
```

**/etc/tomcat7/server.xml**

Uncomment the line:

	<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />

Inside the "Engine Catalina" block add:

```lucee
<Host name="www.mysite.com" appBase="webapps">
  <Context path="" docBase="/var/www/mysite/" />
  <Alias>mysite.com</Alias>
</Host>
```

This file will be the "template" for the 3 instance that we will configure later.

**/etc/default/tomcat7**

This file control the java options of the tomcat server. This depends of your hardware. I only put mine as a reference:

```lucee
JAVA_OPTS="-Djava.awt.headless=true -Xms2048m -Xmx2048m -XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:+UseConcMarkSweepGC"
JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC"
```

The -Xms and -Xmx options controls the memory initial and maximum of the tomcat server. Adjust to your host memory.

### Tomcat multi-instance ###

Multi-instance tomcat it just various tomcat servers with it’s own configuration and each listen in differents ports. In front of this tomcat’s we will put an Apache web server that will route the users requests to the tomcats.

We will install the instances in /var/lib/tomcat7/instanceX/ directories:

	cd /var/lib/tomcat7/
	mkdir instance1 instance2 instance3
	cd instanceX
	mkdir conf logs temp work webapps
	cd ..
	chown -R tomcat7.tomcat7 instance1 instance2 instance3

We now will link the common configuration files, so editing the main /etc/tomcat7/ file, we change the conf of the 3 instance. If you prefer you can copy instead of link, so you can control each instance individually.

	[per instance directory]
	cd conf
	ln -s /etc/tomcat7/catalina.properties .
	ln -s /etc/tomcat7/web.xml .
	ln -s /etc/tomcat7/policy.d/ .

The server.xml needs to be copied into each instance conf directory and its listening ports changed:

	cp /etc/tomcat7/server.xml ./conf/

Edit server.xml and change the lines:

```lucee
<Server port="8001" shutdown="SHUTDOWN">

<Connector port="8081" protocol="HTTP/1.1"
      connectionTimeout="20000"
      URIEncoding="UTF-8"
      redirectPort="8443" />
<Connector port="8101" protocol="AJP/1.3" redirectPort="8443" />
```

In the other two instance change the port to 8002, 8082 and 8102 in instance2 and 8003, 8083 and 8103 in instance3.

### Tomcat instance init script ###

The script that controls tomcat is /etc/init.d/tomcat7. We need to copy this script to control each instance, so we can start/stop each instance individually:

```lucee
cd /etc/init.d
cp tomcat7 tomcat7-instance1
```

Edit the file and add the following line to the definitions block: INSTANCE=instance1

Change: DESC="Tomcat servlet engine" to: DESC="Tomcat servlet engine $INSTANCE"

Change: CATALINA_BASE=/var/lib/$NAME to: CATALINA_BASE=/var/lib/$NAME/$INSTANCE

Change: CATALINA_PID="/var/run/$NAME.pid" to: CATALINA_PID="/var/run/$NAME-$INSTANCE.pid"

Copy the tomcat7-instance1 for the two other instances and edit the INSTANCE variable:


	cp tomcat7-instance1  tomcat7-instance2
	cp tomcat7-instance1  tomcat7-instance3

We can now start each instance:

	service tomcat7-instance1 start
	service tomcat7-instance2 start
	service tomcat7-instance3 start

Configure the scripts to start at system startup:

	update-rc.d tomcat7-instance1 defaults
	update-rc.d tomcat7-instance2 defaults
	update-rc.d tomcat7-instance3 defaults

Disable the original tomcat7:

	update-rc.d tomcat7 disable

Now you can access to each instance in the ports 8081, 8082 and 8083. Remember, each instance have a Lucee server page and configuration:

	http://mysite.com:8081/lucee-context/admin/server.cfm

### APACHE ###

Edit the file /etc/libapache2-mod-jk/workers.properties with:


	workers.tomcat_home=/usr/share/tomcat7
	workers.java_home=/usr/lib/jvm/java-7-openjdk-amd64
	ps=/
	worker.list=loadbalancer
	worker.worker1.port=8101
	worker.worker1.host=localhost
	worker.worker1.type=ajp13

	worker.worker2.port=8102
	worker.worker2.host=localhost
	worker.worker2.type=ajp13

	worker.worker3.port=8103
	worker.worker3.host=localhost
	worker.worker3.type=ajp13

	worker.worker1.lbfactor=1
	worker.worker2.lbfactor=1
	worker.worker3.lbfactor=1
	worker.loadbalancer.type=lb
	worker.loadbalancer.balance_workers=worker1,worker2,worker3

Add the following lines to /etc/apache2/mods-available/jk.conf inside ifModule directive:

	JkMount /*.cfm loadbalancer
	JkMount /*.cfc loadbalancer
	JkMount /*.do loadbalancer
	JkMount /*.jsp loadbalancer
	JkMount /*.cfchart loadbalancer
	JkMount /*.cfm/* loadbalancer
	JkMount /*.cfml/* loadbalancer

	JkMountCopy all
	JkLogFile /var/log/apache2/mod_jk.log

Create a virtual host in /etc/apache2/sites-available/mysite.com

```lucee
<VirtualHost *:80>
  ServerAdmin admin@mysite.com
  DocumentRoot "/var/www/mysite/"
  DirectoryIndex index.cfm index.html
  ServerName mysite.com
  ServerAlias www.mysite.com
  ErrorLog ${APACHE_LOG_DIR}/mysite.error.log
  CustomLog ${APACHE_LOG_DIR}/mysite.access.log Combined
</VirtualHost>
```
Enable the site and reload apache:

	a2ensite mysite.com
	service apache2 restart

Copy your application in /var/www/mysite/ and now we can go to [http://www.mysite.com](http://www.mysite.com/) Lucee admin can be reached at [http://www.mysite.com/lucee-context/admin/server.cfm](http://www.mysite.com/lucee-context/admin/server.cfm)

### If something goes wrong ###

You can check the following logs files:

	/var/log/tomcat7/catalina.out -> Tomcat log
	/var/log/apache2/mod_jk.log -> Module JK log
	/var/log/apache2/error.log -> Apache error log
	/var/log/apache2/mysite.error.log -> Vhost error log

You can test if the tomcat instantces are working correctly going to [http://mysite.com:8081](http://mysite.com:8081/) for instance1 and so on.

