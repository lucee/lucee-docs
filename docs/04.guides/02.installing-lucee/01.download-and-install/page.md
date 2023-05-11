---
title: Download and Installing Lucee
id: running-lucee-download-and-install
menuTitle: Download and Install
---

# Download and Install Lucee Server #

Lucee can be installed and run almost everywhere that is capable of running a [supported Java Version](/guides/installing-lucee/download-and-install.html#supportedJavaVersions). You can even run Lucee on a small RasberryPI. Because of it's great flexibility, Lucee Server comes in different flavors to match your needs (Lucee Express, Lucee Installer, CommandBox, Lucee.jar/Lucee.war). This document will help you decide which one fits best for your purpose.
<br>
<br>

<div class="table-responsive">
<table>
    <thead>
        <tr>
            <th colspan="2">Option 1: Lucee Express (ZIP-File)</th>
        </tr>
    </thead>
	<tbody>
        <tr>
			<td>
				<div class="attribute">Description:</div>
			</td>
			<td>
				<strong>Lucee Express</strong> allows you to quickly test Lucee without installing. This version runs Lucee in a lightweight and portable manner. It doesn't install Java Development Kit (JDK), services nor connectors or other files that are typically installed in a production environment. Lucee Express also ships Tomcat with fewer binaries/scripts.  By default the <strong>Lucee Express</strong> listens on port 8888 (e.g. http://localhost:8888).
			</td>
		</tr>
         <tr>
			<td>
				<div class="attribute">OS:</div>
			</td>
			<td>
				Windows, Linux, MacOS 
			</td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Download:</div>
			</td>
			<td>
			    Download the latest <strong>Lucee Express</strong> Release version <a href="https://lucee.org/downloads.html">here</a>. 
           </td>
		</tr>
		<tr>
			<td>
			<div class="attribute">Includes:</div>
			</td>
			<td>
			    <strong>Lucee Express</strong> ships:<br>     
			        - Lucee.jar (Servlet Container)<br>
                    - Tomcat (Java Servlet Engine)
           </td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Best for:</div>
			</td>
			<td>
				<strong>Lucee Express</strong> is typically used for testing and for local development that doesn't need a fronted webserver.
			</td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Instructions:</div>
			</td>
			<td>
				Simply download the zip file, unzip that file and execute <em>path-to-lucee-express\bin\startup.bat</em> (Windows) or <em>path-to-lucee-express/bin/startup.sh</em> (Linux or Mac), that's all!
        	</td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Note:</div>
			</td>
			<td>
			    To run Lucee Express you still need to have a Java Development Kit (e.g. <a href="https://adoptopenjdk.net/releases.html" target="_blank">AdoptOpenJDK</a>) pre installed on your OS. If you don't want to install a JDK on your OS and instead run Lucee Express with its own dedicated JDK version, you can set the JRE_HOME environment variable pointing to that specific JDK version by using Tomcats <em>path-to-lucee-express\bin\setenv.bat (Windows) or path-to-lucee-express/bin/setenv.sh (Linux)</em> as follows:<br><br>
				<strong>Step 1:</strong> Download the latest Java Development Kit, e.g. <a href="https://adoptopenjdk.net/releases.html" target="_blank">AdoptOpenJDK</a> as ZIP-Version for your OS and unzip it.<br> 
				<strong>Step 2:</strong> For <strong>Windows:</strong> Create a batch file at  <em>path-to-lucee-express\bin\setenv.bat</em> with the following content:

<pre>
REM set a path to a dedicated JDK 
set "JRE_HOME=path-to-your-jdk\"
exit /b 0
</pre>

For <strong>Linux/MacOS:</strong> Create a shell script at  <em>path-to-lucee-express\bin\setenv.sh</em> with the following content:

<pre>
# Set set a path to a dedicated JDK 
JRE_HOME=/path-to-your-jdk/
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
</pre>

<strong>Step 3:</strong> To run Lucee Express execute <em>path-to-lucee-express\bin\startup.bat</em> (Windows) or <em>path-to-lucee-express/bin/startup.sh</em> (Linux or Mac).<br>
For further information, please refer to <a href="https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt">Tomcats 9.0 Documentation (see 3.4)</a>
           </td>
		</tr>
	</tbody>
</table>
</div>
<br>

<div class="table-responsive">
<table>
    <thead>
        <tr>
            <th colspan="2">Option 2: Lucee Installer (.exe/.run binaries files)</th>
        </tr>
    </thead>
	<tbody>

        <tr>
			<td>
				<div class="attribute">Description:</div>
			</td>
			<td>
				<strong>Lucee Installer</strong> is the recommended "all in one" solution for a typical production installation with minimal manual configuration, including service and connectors for fronted webservers ( Apache on Linux / IIS on Windows ). It installs its own dedicated Java Development Kit (AdoptOpenJDK) and comes with the option to install "mod_cfml" for Tomcat's automatic multiple website configuration.
			</td>
		</tr>
             <tr>
			<td>
				<div class="attribute">OS:</div>
			</td>
			<td>
				Windows, Linux
			</td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Download:</div>
			</td>
			<td>
			    Download the latest <strong>Lucee Installer</strong> Release version <a href="https://lucee.org/downloads.html">here</a>.  
           </td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Includes:</div>
			</td>
			<td>
			    <strong>Lucee Installer</strong> ships:<br>     
			    - Lucee.jar (Servlet Container)<br>
				- Tomcat (Java Servlet Engine)<br>
				- AdoptOpenJDK (Java Development Kit)<br>
				- mod_cfml (for Tomcat's automatic host and context configuration - <a href="/guides/installing-lucee/download-and-install.html#mod_cfml">More about mod_cfml</a><br>
 				- Boncode Connector	(for connecting IIS to Tomcat via AJP) - <a href="/guides/installing-lucee/download-and-install.html#BoncodeAJP">More about Boncode</a>  
           </td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Best for:</div>
			</td>
			<td>
				<strong>Lucee Installer</strong> is typically used for production environments where you want have a webserver, e.g. Apache or IIS, acting in front of Lucee/Tomcat and run Lucee as service.
			</td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Instructions:</div>
			</td>
			<td>
				<strong>On Windows:</strong> Run the Lucee Windows Installer file (.exe) as Administrator on a Windows machine with IIS running, so that the installer can detect IIS and connect it with Lucee/Tomcat (Boncode AJP connector and mod_cfml)<br>
                <strong>On Linux:</strong> Run the Lucee Windows Installer file (.run) with sudo user/root on a Linux machine with Apache webserver running, so that the installer can detect Apache and connect it with Lucee/Tomcat (ReverseProxy and mod_cfml). You may need to give the .run file execute permission first to be able to execute it.
	    	</td>
		</tr>
         <tr>
			<td>
				<div class="attribute">Note:</div>
			</td>
			<td>
			  If you are missing the latest "Lucee Installer" Release at Lucee's download site and it's marked as "Coming soon", you can still install the latest available Lucee version with the following steps:<br>
				<strong>Step 1:</strong> Select the latest possible release that has a "Lucee Installer" version available and do the complete installation process.<br>
				<strong>Step 2:</strong> Stop the Lucee/Tomcat service.<br>
				<strong>Step 3:</strong> Download the latest "Lucee.jar" file at Lucee's download page <a href="https://lucee.org/downloads.html">here</a>.<br>
				<strong>Step 4:</strong> Replace the old lucee.jar with the new downloaded Lucee.jar file at <em>path-to-lucee-install/lib/</em>.<br>
				<strong>Step 5:</strong> Delete the folder "lucee-server" at <em>path-to-lucee-install/tomcat/lucee-server</em>.<br>
				<strong>Step 6:</strong> Restart the Lucee/Tomcat service.
		   </td>
		</tr>
    </tbody>
</table>
</div>
<br>

<div class="table-responsive">
<table>
    <thead>
        <tr>
            <th colspan="2">Option 3: CommandBox</th>
        </tr>
    </thead>
	<tbody>

        <tr>
			<td>
				<div class="attribute">Description:</div>
			</td>
			<td>
				<strong>CommandBox</strong> is a commandline tool that greatly simplifies installing and running Lucee. It's very likely the easiest way to run Lucee: Simply open a terminal session from within your webroot, enter the command line 'box server start' and CommandBox will start the latest stable Lucee instance running your web application.<br>
                CommandBox makes use of it's 
				own servlet engine "Undertow" that can be customized through a single .json configuration file. But that's not all you get with CommandBox: Because CommandBox is also a package manager, you can also install and run usefool tools for your CFML development, such as "cfconfig", "CFLint", "taskRunner", "testBox", "CFFormat" or use it to install popular CFML frameworks in a modern scaffolding manner.
			</td>
		</tr>
        <tr>
			<td>
				<div class="attribute">OS:</div>
			</td>
			<td>
				Windows, Linux, MacOS 
			</td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Download:</div>
			</td>
			<td>
			     Please see the <a href="https://www.ortussolutions.com/products/commandbox#download">CommandBox Download-Page</a>
           </td>
		</tr>
        <tr>
			<td>
				<div class="attribute">Best for:</div>
			</td>
			<td>
				<strong>CommandBox</strong> can be used for local development and for production environments. One of the main characteristics of CommandBox is, that it uses one single CommandBox/Undertow instance per webroot/web application.
			</td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Instructions:</div>
			</td>
			<td>
				 Please refer to <a href="https://commandbox.ortusbooks.com/getting-started-guide">CommandBox Start Guide</a>
        	</td>
		</tr>
    </tbody>
</table>
</div>
<br>

<div class="table-responsive">
<table>
    <thead>
        <tr>
            <th colspan="2">Option 4: Custom Installation (Lucee.jar/Lucee.war) </th>
        </tr>
    </thead>
	<tbody>

        <tr>
			<td>
				<div class="attribute">Description:</div>
			</td>
			<td>
				<strong>Lucee.jar</strong> is the pure stand alone servlet containers of Lucee as compressed Java ARchive (also known as JAR-file) and <strong>Lucee.war</strong> is a Web application ARchive (also known as WAR-file) containing the Lucee.jar. Use these files if you want to run Lucee in different environments with different servlet engines (e.g. Undertow, Jetty or cloud based servlet engines like AWSElasticBeanstalk).
                <br>                
                You may also use Lucee.jar for upgrading/downgrading Lucee installations without a complete re-installation by simply replacing the .jar file in the servlets engine library folder. If so, please make always sure to backup Tomcat, all server- and web-contexts and your configurations before upgrading.
			</td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Download:</div>
			</td>
			<td>
			    Download the latest <strong>Lucee.jar</strong> or <strong>Lucee.war</strong> Release version <a href="https://lucee.org/downloads.html">here</a>.  
           </td>
		</tr>
		<tr>
			<td>
				<div class="attribute">Includes:</div>
			</td>
			<td>
			    - Lucee.jar (Servlet Container as JARchive File) or <br>
				- Lucee.war (WARchive containing also Lucee.jar)<br>
	       </td>
		</tr>
	    <tr>
			<td>
				<div class="attribute">Best for:</div>
			</td>
			<td>
				<strong>Custom Installation</strong> is used for other environments running Java Servlet Engines or Java Web Application Archives, such as Undertow, Jetty, cloud based servlet engines like AWSElasticBeanstalk and others.
			</td>
		</tr>
    </tbody>
</table>
</div>
<br>

<a name="releaseWorkflow"></a>

### The difference between "Snapshots", "Release Candidates (RC)" and "Stable Releases" of Lucee downloads ###

At [https://download.lucee.org](https://download.lucee.org) you will find the downloads categorized as "Releases" for Stable Releases, "RC" for Release Candidates, and "Snapshots". These file names are a reference to Lucee's continuous integration workflow.

The Lucee development team is constantly making changes to the Lucee source code. These changes are released almost daily and called **Snapshots**. This gives Lucee developers the ability to quickly get a "Snapshot" of Lucee in its development timeline.

Once the Lucee code reaches a certain level of maturity in its development cycle, a corresponding snapshot is carefully selected and also published as a **Release Candidate (RC)** for broad testing. This is the phase where the Lucee development team focuses on fixing new regressions with the highest priority.

Once the new bugs and regressions are fixed, a stable snapshot is selected and released as a **Stable Release**.

### Explanation of the Lucee Version Numbers ###

Whenever Lucee publishes a "Release" for Stable Releases, "RC" for Release Candidate, and "Snapshot"  the version number is added to each build (e.g. **5.3.10.120**). The version numbering is a direct reference to a development state in the development timeline. It follows a pretty standard release process using (mostly) semantic versioning. The version numbers are built as follows:

`major.minor.patch.build`

- **major** is a paradigm shifting release where major overhauls happen
- **minor** releases are when breaking changes are made and happen once a year or so
- **patch** releases represent a stable collection of bug fixes and enhancements
- **builds** represent a single commit/build fixing one issue or adding one feature

Because the version number reflect the state of development, the Lucee Engine builds will also be consistent across all these categories **whenever they have an identical version number**. 

As an example: 
**Release 5.3.10.120, RC 5.3.10.120 and Snapshot 5.3.10.120** reflect the very same Lucee Engine *build* in its development timeline. Thus, all these Lucee engines are identical too.

<a name="supportedJavaVersions"></a>

### Java Versions Supported ###

- The Official Lucee Installer comes with Java 11, which is our recommended version
- Java 8 is still officially supported for 5.3, with Lucee 6 it will be no longer officially supported, but will be unofficially, as long as feasible
- Lucee Supports Java 9 since version 5.3.0.57
- Java 16 is not currently supported due to breaking internal changes with the jvm, [LDEV-3526](https://luceeserver.atlassian.net/browse/LDEV-3526)

### Java Support tips ###

- When reporting a bug with Lucee, **please always describe your stack** (Lucee version, Java Version, Tomcat/etc version and the Extension version, if it's extension related)
- If you aren't running the latest release of Java and encounter a problem, please try updating your Java version before reporting a bug, especially if it's several years old!

<a name="mod_cfml"></a>

### Using Lucee with multiple websites, mod_cfml ###

Lucee doesn't support multiple webserver hosts directly, however [mod_cfml](https://viviotech.github.io/mod_cfml/index.html) is available to achieve this. Mod_cfml is capable to identify new CFML web applications on the fronted webservers side, such as IIS on Windows or Apache on Linux, and automatically add the necessary configuration to your Lucee/Tomcat configuration.

<a name="BoncodeAJP"></a>

### Boncode AJP Connector ###

To connect Microsofts Internet Information Services (IIS) with Lucee/Tomcat the Lucee Installer uses the Boncode connector using Apache JServ Protocol (AJP). For further information about Boncode AJP, FAQs and troubleshooting, please refer to [Boncode AJP Documentation](http://www.boncode.net/boncode-connector)

### Developer Forum ###

If you do not find the answers you are looking for here, we encourage you to post to Lucee-Dev. There are many friendly members of the community who are willing to help:

[Lucee Developer Forum](https://dev.lucee.org)
