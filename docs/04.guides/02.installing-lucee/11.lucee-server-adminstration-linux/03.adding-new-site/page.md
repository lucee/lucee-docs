---
title: Adding Sites
id: linux-adding-sites
---

### Adding Sites to Linux ###

The Linux Lucee Installer for Linux is designed to make it easy to add new sites to your system and have them function relatively well "out of the box". The following documentation describes the recommended steps for adding new sites to Linux systems using the Lucee 4 Installers. Please check this documentation after major point releases as the process for adding may change as technology advances.

### Supported OS's ###

The Lucee Linux Installer fully supports modern and supported releases of Debian/Ubuntu and RHEL/CentOS installations in their native formats. If an OS is no longer supported by it's publishing organization, the Lucee Distribution Team does not guarantee that it will be supported by our team. Some derivatives, or services that alter the base release of OS's (like Amazon Linux) and customize the kernel and/or included programs such as BASH, may not be supported, but we will make an effort to support them if there are several users attempting to use a specific OS version (like Amazon Linux) or release.

### Assumptions ###

These instructions are going to assume that you're running Lucee in a production environment under the "lucee" user. Note that this is DIFFERENT then the default "root" user. If you're using the default "root" user, then many of the permissions we review below will not apply to you, as root has access to everything on a Linux system.

Last, I'm going to assume we're running under Ubuntu in these examples. If you're running RHEL/CentOS, you do not need to "sudo" like many of the examples below show. Just leave that part off of your commands and you'll be fine.

### Manually Adding Sites to Apache ###

Adding a new site to Apache can be as easy as adding a new site to your control panel (Like VirtualMin), or new sites can be added manually. The following documentation reviews the recommended process of manually adding a new site to Apache.

### Create a Directory ###

The first thing you need to do to create a new site on your system is to create a directory where your files will be stored. There are many conventions you can follow, but for the purpose of being easy to integrate into other services, we recommend you follow the user-based method for creating sites. This method is useful if you need to integrate other user-based services, such as FTP or SSH. Using the method below, isolating services based on user accounts would be simple to do.

In the example below, I'm going to add a website called "utdream.org", with a user account ironically named "utdream". You will need to customize the username and the site name to the site that you're adding.

Open a command-line window to your server and run the following commands (this is in Ubuntu):

	$ sudo useradd -k utdream

The above command creates the user and group (both named "utdream") and creates the home directory in /home/utdream/.

	$ sudo mkdir -p /home/utdream/public_html/WEB-INF

This command ensures that the skeleton home directory includes a public_html directory and the WEB-INF directory under it. Your site files would be stored in the public_html directory, and the WEB-INF directory is where Lucee will store it's files for this site.

	$ sudo chmod 755 /home/
	$ sudo chmod 755 /home/utdream
	$ sudo chmod 755 /home/utdream/public_html
	$ sudo chown lucee:lucee /home/utdream/public_html/WEB-INF/

These "chmod" commands set the permissions to the new directories so that the lucee user that Lucee Server is using as will be able to write to the WEB-INF directory like it needs to, as well as read what's in the public_html directory.

	$ gpasswd -a lucee utdream
	$ gpasswd -a utdream lucee

Last, we need to update group permissions. The above two commands add the "lucee" user to the "utdream" group, and the "utdream" user to the "lucee" group. This method ensures that if we maintain group write permissions on our files, that both our "lucee" user and our "utdream" user will always be able to edit the files they need to.

For example, if you upload a file using FTP it will have the user and group of "utdream:utdream", but if that file has group write permissions and the "lucee" user is a member of the "utdream" group, then Lucee server will have the ability to edit that file as well.

Conversely, if you create a webapp that has a file upload process, and use that to upload a file, it will be owned by the user and group of "lucee:lucee", because it was uploaded through Lucee Server. So, if you want to then manage that file through FTP with the "utdream" user, you can as long as that file has group write permissions.

Using this method, if you ever find you don't have permission to do what you need to, just run the following command to add group write permissions and you should be all set!

	$ sudo chmod g+w myfile.cfm

This will allow anyone who is a member of the file's group to be able to write to it.

### Add Your Host to Apache ###

Now that we have the directory that we'll be putting our site in all sorted, let's create a new site in Apache. This will tell Apache where it can find the files for a particular site whenever it gets a request for that site.

To create a new site, or "VirtualHost", in Apache, we need to add some lines to the Apache configuration. In Debian/Ubuntu systems, this is /etc/apache2/apache2.conf. In RHEL/CentOS systems, this file is in /etc/httpd/conf/httpd.conf. You will need to be comfortable updating files with a text editor on Linux. I like VIM. Since we're using Ubuntu here in our example, I'll use vim on my Apache config:

	$ sudo vim /etc/apache2/apache2.conf

Next I'm just going to scroll to the bottom and add the following:

```lucee
<VirtualHost *:80>
  ServerAdmin jordan@utdream.org
  DocumentRoot /home/utdream/public_html/
  ServerName utdream.org
  ServerAlias www.utdream.org
</virtualhost>
```

### Connecting Apache Hosts to Tomcat/Lucee ###

Next we need to tell Apache what to do when it gets a request for a CFM file. There are several ways to accomplish this.

### Automatically Connecting Apache Hosts to Tomcat/Lucee (with mod_cfml) ###

The Lucee installer (starting with version 4.?.?) configures Apache and Tomcat with mod_cfml, which enables automatic connectivity between Apache and Tomcat/Lucee. With mod_cfml, no further configuration changes to the Apache virtual host or Tomcat configuration are necessary.

The following graph gives an overview of how mod_cfml works in conjunction with mod_proxy. (The Lucee installer configures mod_cfml to connect via mod_proxy, but mod_cfml itself can be optionally configured to use mod_jk, as well.)

**Pros**

This is the easiest way to get up and running, since no extra configuration steps are needed to connect any number of Apache virtual hosts to Tomcat/Lucee.

**Cons**

If a site can be accessed by many aliases (if many ServerAliases are specified, or especially if ServerAliases with wildcards are specified), then extra files and on-the-fly configuration overhead result.* However, if there are a finite number of aliases, this isn't a problem.

* [https://groups.google.com/forum/#!msg/lucee/y9qS_L_cNUc/4GCqCWbS_KcJ](https://groups.google.com/forum/#!msg/lucee/y9qS_L_cNUc/4GCqCWbS_KcJ)

For more information, see the mod_cfml documentation: [http://www.modcfml.org](http://www.modcfml.org/)

### Manually Connecting Apache Hosts to Tomcat/lucee ###

#### Manually Connecting Apache Hosts to Tomcat/Lucee (Apache Side) ####

There are several manual ways to connect Apache to Tomcat/Lucee:

**Manually Connecting with mod_proxy**

The simplest manual way to configure a CFML "handler" is with mod_proxy - which means that Apache will just act as a tunnel (proxy) between the user and Tomcat when a CFML request comes in.

start out by making sure mod_proxy is installed on to our Ubuntu system:

	$ sudo apt-get install libapache2-mod-proxy-html

Next we need to enable our newly installed mod_proxy module:

	$ sudo a2enmod proxy_http

Now we can add out proxy config to Apache:

	$ sudo vim /etc/apache2/apache2.conf

Then add the following:

```lucee
<IfModule mod_proxy.c>
    <Proxy *>
    Allow from 127.0.0.1
    </proxy>
    ProxyPreserveHost On
    ProxyPassMatch ^/(.+\.cf[cm])(/.*)?$ http://127.0.0.1:8888/$1$2
    ProxyPassMatch ^/(.+\.cfchart)(/.*)?$ http://127.0.0.1:8888/$1$2
    ProxyPassMatch ^/(.+\.cfml)(/.*)?$ http://127.0.0.1:8888/$1$2
    # optional mappings
    #ProxyPassMatch ^/flex2gateway/(.*)$ http://127.0.0.1:8888/flex2gateway/$1
    #ProxyPassMatch ^/messagebroker/(.*)$ http://127.0.0.1:8888/messagebroker/$1
    #ProxyPassMatch ^/flashservices/gateway(.*)$ http://127.0.0.1:8888/flashservices/gateway$1
    #ProxyPassMatch ^/openamf/gateway/(.*)$ http://127.0.0.1:8888/openamf/gateway/$1
    #ProxyPassMatch ^/rest/(.*)$ http://127.0.0.1:8888/rest/$1
    ProxyPassReverse / http://127.0.0.1:8888/
</ifmodule>
```

Now just restart Apache and you should be all set!

	$ sudo /etc/init.d/apache2 restart

**Manually Connecting with mod_proxy_ajp**

mod_proxy_ajp is another proxy method that, instead of proxying the request over HTTP, will proxy the request over AJP. There are some advantages to this, such as HTTPS detection and other built-in features. The down-side is that mod_proxy_ajp can be difficult to find/install. Sometimes it is not available in the OS repository, and you have to compile/install it yourself. If you're able to get mod_proxy_ajp installed into Apache, then you can update the statements made above and point them to the AJP port using the AJP protocol, like so:

```lucee
<Proxy *>
Allow from 127.0.0.1
</proxy>
ProxyPreserveHost On
ProxyPassMatch ^/(.+\.cf[cm])(/.*)?$ ajp://127.0.0.1:8009/$1$2
ProxyPassMatch ^/(.+\.cfchart)(/.*)?$ ajp://127.0.0.1:8009/$1$2
ProxyPassMatch ^/(.+\.cfml)(/.*)?$ ajp://127.0.0.1:8009/$1$2
ProxyPassReverse / ajp://127.0.0.1:8009/
```

Notice the "ajp://" and port "8009".

### Manually Connecting with mod_jk ###

The Apache Foundation no longer offers pre-compiled binaries for mod_jk, but if you're comfortable compiling things or if you can find mod_jk in your distributions repository, then you can connect Apache to Lucee's instance of TOmcat with a config like this:

```lucee
<IfModule !mod_jk.c>
	LoadModule jk_module [path to]/mod_jk.so
</ifmodule>
```

```lucee
<IfModule mod_jk.c>
	JkMount /*.cfm ajp13
	JkMount /*.cfc ajp13
	JkMount /*.do ajp13
	JkMount /*.jsp ajp13
	JkMount /*.cfchart ajp13
	JkMount /*.cfm/* ajp13
	JkMount /*.cfml/* ajp13
	# Flex Gateway Mappings
	# JkMount /flex2gateway/* ajp13
	# JkMount /flashservices/gateway/* ajp13
	# JkMount /messagebroker/* ajp13
	JkMountCopy all
	JkLogFile [path to]/mod_jk.log
</ifmodule>
```

Be sure to update [path] to something that actually exists.

Manually Connecting Apache Hosts to Tomcat/Lucee (Tomcat Side)

If you are manually configuring connections between Apache and Tomcat/Lucee, then the Tomcat side needs to be configured as well. (If you are using mod_cfml, then this is handled automatically.)

Configuring Tomcat is nearly identical to configuring Apache, you just have to edit Tomcat's server.xml file instead of the Apache config file.

The default location of the server.xml file is /opt/lucee/tomcat/conf/server.xml. The file has been commented (look near the bottom) and read the comments carefully. You should see something like this:

```lucee
< !-- Define the default virtual host
    Note: XML Schema validation will not work with Xerces 2.2.
       -->
      <Host name="localhost" appBase="webapps"
            unpackWARs="true" autoDeploy="true"
            xmlValidation="false" xmlNamespaceAware="false">
      </host>
      < !--
        Add additional VIRTUALHOSTS by copying the following example config:
        REPLACE:
        [ENTER DOMAIN NAME] with a domain, IE: www.mysite.com
        [ENTER SYSTEM PATH] with your web site's base directory. IE: /home/user/public_html/ or C:\websites\www.mysite.com\ etc...
        Don't forget to remove comments! ;)
      -->
      < !--
        <Host name="[ENTER DOMAIN NAME]" appBase="webapps"
             unpackWARs="true" autoDeploy="true"
             xmlValidation="false" xmlNamespaceAware="false">
             <Context path="" docBase="[ENTER SYSTEM PATH]" />
             <Alias>[ALTERNATE DOMAIN NAME]</alias>
        </host>
      -->
     </engine>
   </service>
</server>
```