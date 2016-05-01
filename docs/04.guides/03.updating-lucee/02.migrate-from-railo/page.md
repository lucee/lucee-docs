---
title: Migrate from Railo
id: updating-lucee-migrate-from-railo
---

# Migrate from Railo<sup>&copy;</sup>#
Lucee 4.5 is forked from the Railo CFML Server (version 4.2) so you can easily migrate an existing Railo installation as follows.

**Please read all the instructions before you get started.**

**Please note, these instruction apply to Lucee 4.5 ONLY**

*Lucee will rewrite some of the configuration files in your existing installation. It will also do a backup of the original contents as a zip file (see below) in case you need to roll back, but it's advisable to make a backup of the original installation just in case.*

1. Download the latest Lucee "custom" package "JARs 4.5 (Stable)" from the [download section](http://lucee.org/downloads.html) and unzip it somewhere.
2. Stop your Railo server.
3. In the zip file you will find a file called `lucee.jar`. Use that JAR to replace the existing `railo.jar` in your Railo installation's `lib` directory.

    **Important: make sure you *remove* the railo.jar completely. Do not just rename it (e.g. to "railo.jar.bak"), otherwise most servlet engines will still pick it up!**

4. Replace the rest of the jars in the `lib` directory with the jars from the zip file. The jars have the same names as the original files so you can simply copy them to the directory.
5. Restart your Railo Server which will now convert itself into a Lucee Server.

When it first starts, Lucee rewrites the server context and all individual web contexts. All the changes made are logged in detail to the `application.log` log file. To see these entries make sure the `application.log` file has set the log level "Info" or less. In the process Lucee does a backup of each original context in a zip file named using the pattern "railo-[server|web]-context-old.zip".

## IIS BonCode connector

If you are using the [BonCode connector for IIS/Tomcat](http://tomcatiis.riaforge.org/), you may need to update to the 1.0.20 (or later) version which supports Lucee.

1. [Download](http://tomcatiis.riaforge.org/) version 1.0.20 (or later)
2. From the AJP13 folder inside the downloaded zip, copy the following 2 files to the `BIN` directory in each of your web roots, replacing the existing files:

- `BonCodeAJP13.dll`
- `BonCodeIIS.dll`

## Server/Web administrator URLs

To access the server admin and individual web context admin GUIs, you will need to replace "/railo-context/" in each URL with "/lucee/". For example instead of

http://localhost:8888/railo-context/admin/server.cfm

you should now use:

http://localhost:8888/lucee/admin/server.cfm

## Optional Steps ##
Lucee only converts the Railo config settings, it does not touch your Servlet Engine configuration since Lucee will work with the existing Railo configuration.

### web.xml (jetty)/webdefault.xml (tomcat) ###
You **can** for example change the class names in the servlet definitions from

```xml
<servlet>
    <servlet-name>GlobalCFMLServlet</servlet-name>
    <description>CFML runtime Engine</description>
   <servlet-class>railo.loader.servlet.CFMLServlet</servlet-class>
    <init-param>
        <param-name>railo-web-directory</param-name>
       <param-value>{web-root-directory}/WEB-INF/railo/</param-value>
        <description>Railo Web Directory directory</description>
    </init-param>
    <init-param>
        <param-name>railo-server-root</param-name>
        <param-value>D:\webroot</param-value>
        <description>Directory where Lucee server root is stored.</description>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

to

```xml
<servlet>
    <servlet-name>GlobalCFMLServlet</servlet-name>
    <description>CFML runtime Engine</description>
   <servlet-class>lucee.loader.servlet.CFMLServlet</servlet-class>
    <init-param>
        <param-name>lucee-web-directory</param-name>
       <param-value>{web-root-directory}/WEB-INF/lucee/</param-value>
        <description>Lucee Web Directory directory</description>
    </init-param>
    <init-param>
        <param-name>lucee-server-root</param-name>
        <param-value>D:\webroot</param-value>
        <description>Directory where Lucee server root is stored.</description>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

but doing so isn't necessary and makes no difference to Lucee.
**When you change a path like "D:\projects/whatever/railo/server" to "D:\projects/whatever/lucee/server", Lucee will no longer find the original configuration and because of that not migrating it, so it is really better to changes paths like this AFTER the migration! **

The same applies to the "railo-inst.jar" defined in your start script: you can change it but it is not necessary.

## Extensions
Partially or fully Java based extensions that rely on certain Railo interfaces may not work and could possibly prevent Lucee from starting.

The following extensions need to be updated in order to work with Lucee. It is best uninstall them before you migrate then re-install them afterwards so that you get the new Lucee compatible versions:

- All cache extensions (Memcached, Infinispan)
- MongoDB extension

This list will be added to as issues come to light.

###Spreadsheet

The original [Railo extension produced by TeamCfAdvance](https://github.com/teamcfadvance/cfspreadsheet-railo) is not compatible with Lucee and should be removed.

However a [modified version by Andrew Kretzer](https://github.com/Leftbower/cfspreadsheet-lucee) is now available and can be installed in Lucee by carefully following the instructions provided.

Alternatively, a standalone (non-extension) [spreadsheet library for Lucee](https://github.com/cfsimplicity/lucee-spreadsheet) is available which supports almost all of the extension's functionality.

###Video

If you have installed the Video extension, you may see the following error: `java.lang.NoClassDefFoundError: railo/runtime/video/VideoExecuter`. To fix this simply [download the railo-video-extension-adapter-for-lucee.jar](https://bitbucket.org/lucee/lucee/downloads/railo-video-extension-adapter-for-lucee.jar) and place it next to the "railo-extension-video.jar" in your installation.

##org.railo.cfml... component paths

If you have used the component path *org.railo.cfml...* as a **return or argument type**, it must be changed to *org.lucee.cfml*, eg.

```javascript
org.railo.cfml.Query function newQuery(){
   return new Query();
}
```

These CFCs may be affected:

   ![cfcs.jpg](https://bitbucket.org/repo/rX87Rq/images/2979463242-cfcs.jpg)

###objectSave()
Objects persisted with *objectSave()* on Railo, can not be loaded with *objectLoad()* on Lucee.


###Other issues?

If you are having problems please post to the [Lucee Google Group](https://groups.google.com/forum/#!forum/lucee).
