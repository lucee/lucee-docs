---
title: System Properties
id: running-lucee-system-properties
---

## System Properties and Environment Variables ##

This documentation shows how to set and use *Environment Variables* or *System Properties* to configure specific Lucee Server settings.
<br>
<br>

### 1. Introduction ###

Lucee settings are usually configured manually within the Server Administrator for server-context  or in Web Administrator for web-context. While settings for web-context are also configurable through your web applications Application.cfc (see [[tag-application]]), specific server-context settings can be configured with *Environment Variables* or *System Properties* (since Lucee 5.3). This gives administrators and developers power to tweak server settings from startup without having to configure in the server administrators web interface. For example, pre-define the extensions to be installed, enable full null support or define charsets for your running Lucee server instance.
<br>
<br>

### 2. Naming Notation ###

On startup Lucee identifies specific *Environment Variables* or JVM *System Properties* and uses them for the server setting configuration. While system environment variable names need to be notated as *MACRO_CASE*, system property names need to be in *dot.notation*. See as an example of variable/property name notation for enabling full null support in the table below:

|  Use as 	|	Notation Example	|
|---	|---	|
|	  Environment Variables	| `LUCEE_FULL_NULL_SUPPORT=true` *(MACRO_CASE)*	|
|	  System Properties		| `lucee.full.null.support=true` *(dot.notation)* |
<br>

### 3. Setting The Variables ###

There are many different ways to make *Environment Variables* or *System Properties* available to Lucee depending on how you're running the Lucee server instance.
<br>
<br>

### 3.1 How To Set Environment Variables ###

Find below a brief overview of available options about where and how to set your *Environment Variables*:

|  Where | Variables availablility| How to configure |
|---	|---	|---	|
| OS (globally)| OS (system-wide)| Environment variables are configured within your OS configuration. Please refer to the documentation of your OS |
| OS (user specific) | OS (system-wide), but limited to user | Environment variables are configured within the OS user's profile configuration. Please refer to the documentation of your OS  |
|  Servlet Engine Tomcat | Limited to the running servlet instance  |  **Option I:** Use Tomcats *path-to-lucee-installation\tomcat\bin\setenv.bat (Windows) or path-to-lucee-installation\tomcat\bin\setenv.sh (Linux)*  as specified in [Tomcats 9.0 Documentation (see 3.4)](https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt)<br> **Option II:** Run Tomcat with the argument *--Environment=key1=value1;key2=...* as specified in  [Tomcat 9 parameters](https://tomcat.apache.org/tomcat-9.0-doc/windows-service-howto.html) |
| CommandBox | Limited to the running CommandBox instance | Since CommandBox 4.5 *Environment Variables* can be set in a file named ".env". You can easily create the .env file by running the command `dotenv set` from your CommanBox CLI. For more information please see [How to set it up CommandBox with .env files](https://github.com/commandbox-modules/commandbox-dotenv) and [CommandBox Environement Variables](https://commandbox.ortusbooks.com/usage/environment-variables) |

In the following example we'll follow Tomcats recommendation and set *Environment Variables* by using Tomcats setenv.bat/setenv.sh files.

**For Windows:** Create a batch file at  *path-to-lucee-installation\tomcat\bin\setenv.bat* with the following content:

```
REM Keep all struct keys defined with "dot notation" in original case.
set "LUCEE_PRESERVE_CASE=true"

REM Enable full null support
set "LUCEE_FULL_NULL_SUPPORT=true"

REM Set Simple whitespace management
set "LUCEE_CFML_WRITER=white-space"
```

**For Linux:** Create a shell script at  *path-to-lucee-installation\tomcat\bin\setenv.sh* with the following content:

```
# Keep all struct keys defined with "dot notation" in original case.
LUCEE_PRESERVE_CASE=true

# Enable full null support
LUCEE_FULL_NULL_SUPPORT=true

# Set Simple whitespace management
LUCEE_CFML_WRITER=white-space
```

**Important**: *When creating batch/shell script files for Tomcat, please make sure their permissions are correctly set for the user running Tomcat to read and execute them.*
<br>
<br>

### 3.2 How To Set System Properties ###

System Properties are specific to the JVM servlet container engine. Just like Environment Variables they can be configured at different locations. In this example we will focus on configuring *System Properties* when running Lucee with Tomcat or  CommandBox. Here is a brief overview.

|	Configuration for | How to configure |
|---				 |---					 |
|	Servlet Engine Tomcat | Use Tomcats *path-to-lucee-installation\tomcat\bin\setenv.bat or path-to-lucee-installation\tomcat\bin\setenv.sh* and add the system property using `CATALINA_OPTS`. See [Tomcats 9.0 Documentation (see 3.3)](https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt)	|
 CommandBox | In CommandBox *System Properties* can be set like Environment Variables in the `.env` file. |

In Tomcat *System Properties* are passed to the JVM servlet engine Tomcat on startup by populating CATALINA_OPTS with the -D flag, e.g. `-Dlucee.full.null.support=true` (note that there is no space between the -D flag and the system property key/value). In Tomcat it's recommended to set CATALINA_OPTS in the setenv.bat/setenv.sh file.

**For Windows:** Create a batch file at  *path-to-lucee-installation\tomcat\bin\setenv.bat* with the following content:

```
REM Set System Properties with CATALINA_OPTS
set "CATALINA_OPTS=-Dlucee.full.null.support=true -Dlucee.cfml.writer=white-space -Dlucee.cfml.writer=white-space"
```

**For Linux:** Create a shell script at  *path-to-lucee-installation\tomcat\bin\setenv.sh* with the following content:

```

# Set System Properties with CATALINA_OPTS
CATALINA_OPTS=-Dlucee.full.null.support=true -Dlucee.cfml.writer=white-space -Dlucee.cfml.writer=white-space
```

**Important**: *When creating batch/shell script files for Tomcat, please make sure their permissions are correctly set for the user running Tomcat to read and execute them.*
<br>
<br>

If you are running Lucee with **CommandBox**, you can make use of *System Properties* by saving them to the `.env` file, just the same way it's done with *Environment Variables*. For further information please see [How to set it up CommandBox with .env files](https://github.com/commandbox-modules/commandbox-dotenv) and [CommandBox Environment Variables](https://commandbox.ortusbooks.com/usage/environment-variables).
<br>
<br>

### 5. Verifying Variables/Properties Passed To Lucee ###

To make sure the *Environment Variables/System Properties* are properly being passed to Tomcat/Lucee, you can simply dump these variables from within your web application with cfml as follows:

```
<cfscript>
writeDump(server.system.environment);
writeDump(server.system.properties);
</cfscript>
```

<br>

### 6. Security Consideration ###

When using *Environment Variables* or *System Properties* you need to consider important security implications. This is because the data stored in this sort of variables or files may be accessible by other users sharing the same OS or running servlet engine instance. Storing sensitive information e.g. hashed passwords, access-tokens, user names, database names, etc on OS or files has to be considered very carefully. Also, make sure not to publish these files with sensitive data as as part of open source code in public repositories.
<br>
<br>

### Environment Variables/System Properties Reference For Lucee Server Settings ###

<div class="table-responsive">
<table>
	<thead>
		<tr>
			<th>Variable/Property</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<div class="attribute">LUCEE_ADMIN_ENABLED<br>lucee.admin.enabled</div>
			</td>
			<td>
				Enables/disables access to Lucee Server/Web Administrator. If set to <code>false</code>, Lucee will respond with a 404 http status error for Administrator pages.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>
		
		<tr>
			<td>
				<div class="attribute">LUCEE_EXTENSIONS_INSTALL<br>lucee.extension.install</div>
			</td>
			<td>
				Enables/disables installation of Lucee's default extensions. When this value is changed, it will need a complete redeployment of "lucee-server" (simple restart won't suffice). This directive is very useful in combination with the system variable LUCEE_EXTENSIONS.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_EXTENSIONS<br>lucee.extensions</div>
			</td>
			<td>
				Comma separated list of extension GUIDs (Globally Unique Identifiers) to be downloaded and installed during the very first server start. Setting GUID alone will install latest version.
				If you want to dictate version, append <code>;version=xx.xx.xx.xx</code> to the GUID.
				You can find available extensions and their corresponding GUID (these are listed as IDs) in the Server Administrator or at
				<a href="https://downloads.lucee.org" target="_blank">Lucee Downloads</a>.
				<br>
				<sub>Values: String</sub>
				<p>
					<strong>Example:</strong> Installing JFreeChart Extension Version 1.0.19.19:
					<pre lang="script">LUCEE_EXTENSIONS=D46B46A9-A0E3-44E1-D972A04AC3A8DC10;version=1.0.19.19</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_ENABLE_BUNDLE_DOWNLOAD<br>lucee.enable.bundle.download</div>
			</td>
			<td>
				Enables bundle download. Setting it to <code>false</code> makes sure that only bundles shipped with <code>Lucee.jar</code> are installed.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_TEMPLATE_CHARSET<br>lucee.template.charset</div>
			</td>
			<td>
				Default charset used to read templates of <code>*.cfm</code> and <code>*.cfc</code> files
				<br>
				<sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Charset &raquo; Template charset
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">// as cfscript<br>&lt;cfscript&gt;<br>processingdirective pageEncoding="UTF-8";<br>&lt;/cfscript&gt;</pre>
					or
					<pre lang="html">&lt;!--- as cftag ---&gt;<br>&lt;cfprocessingdirective pageEncoding="UTF-8"&gt;</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_WEB_CHARSET<br>lucee.web.charset</div>
			</td>
			<td>
				Default character set for output streams, form-, url-, and cgi scope variables and reading/writing the header.
				<br>
				<sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Charset &raquo; Web charset
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">// Application.cfc<br>this.charset.web="UTF-8";</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_RESOURCE_CHARSET<br>lucee.resource.charset</div>
			</td>
			<td>
				Default character set for reading from/writing to various resources.
				<br>
				<sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Charset &raquo; Resource charset
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">// Application.cfc<br>this.charset.resource="UTF-8";</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_SCRIPT_PROTECT<br>lucee.script.protect</div>
			</td>
			<td>
				The configuration of Script protect, secures the system from "cross-site scripting" various resources.
				<br>
				<sub>Values: String <code>none | all | cgi , url , form , cookie</code></sub>
				<p>
					<strong>Example:</strong> The following directive will set script protection for url and form scope:
					<pre lang="script">LUCEE_SCRIPT_PROTECT=url,form</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Request &raquo; Script-Protect
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_QUEUE_ENABLE<br>lucee.queue.enable</div>
			</td>
			<td>
				Enables the queue for requests.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Request &raquo; Concurrent Requests &raquo; Enable
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_QUEUE_MAX<br>lucee.queue.max</div>
			</td>
			<td>
				The maximum concurrent requests that the engine allows to run at the same time,
				before the engine begins to queue the requests.
				<br>
				<sub>Values: Numeric</sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Request &raquo; Concurrent Requests &raquo; Maximal
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_QUEUE_TIMEOUT<br>lucee.queue.timeout</div>
			</td>
			<td>
				The time in milliseconds a request is held in the queue.
				If the time is reached the request is rejected with an exception.
				If you have set 0 milliseconds the request timeout is used instead.
				<br><sub>Values: Numeric</sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Request &raquo; Concurrent Requests &raquo; Timeout
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_CFML_WRITER<br>lucee.cfml.writer</div>
			</td>
			<td>
				Defines whitespace management of the server.<br> 
				
				<ul>
					<li><strong>regular</strong>: No whitespace management.</li>
					<li><strong>white-space</strong>: Simple whitespace management - 
					every whitespace character that follows whitespace is removed.</li></li>
					<li><strong>white-space-pref</strong>: Smart whitespace management - every whitespace character that follows a whitespace is removed, 
					but whitespace inside the tags: &lt;code&gt;, &lt;pre&gt; and &lt;textarea&gt; is kept</li>
				</ul>
				<br>
				<sub>Values: String <code>white-space-pref | regular | white-space</code></sub>
				<p>
					<strong>Example:</strong> The following directive will set whitespace management to simple:
					<pre lang="script">LUCEE_CFML_WRITER=white-space</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Output &raquo; Whitespace management
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_SUPPRESS_WS_BEFORE_ARG<br>lucee.suppress.ws.before.arg</div>
			</td>
			<td>
				If set, Lucee suppresses whitespace defined between the "cffunction" starting tag and the last "cfargument" tag.
				This setting is ignored when there is a different output between this tags as white space
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Language/Compiler &raquo; Suppress whitespace before cfargument
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_PRESERVE_CASE<br>lucee.preserve.case</div>
			</td>
			<td>
				Keep all struct keys defined with "dot notation" in original case. If set to false,
				all dot.notated key-names will be converted to UPPERCASE.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Language/Compiler &raquo; Key case
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">// as cfscript<br>&lt;cfscript&gt;<br>processingdirective preserveCase="true";<br>&lt;/cfscript&gt;</pre>
					or
					<pre lang="html">&lt;!--- as cftag ---&gt;<br>&lt;cfprocessingdirective preserveCase="true"&gt;</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_ALLOW_COMPRESSION<br>lucee.allow.compression</div>
			</td>
			<td>
				Enables/disables compression (GZip) for the Lucee Response stream for text-based responses when supported by the
				client (Web Browser)
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Language/Compiler &raquo; Compression
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">//Application.cfc<br>this.compression = false;</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_FULL_NULL_SUPPORT<br>lucee.full.null.support</div>
			</td>
			<td>
				Enables/disables full null support, support for null, including "null" literal.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Language/Compiler &raquo; Null Support
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">//Application.cfc<br>this.nullsupport = true;</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_CASCADE_TO_RESULTSET<br>lucee.cascade.to.result</div>
			</td>
			<td>
				Enables/disables search of available resultsets when variables have no scope defined, e.g. #myVar# instead
				of #variables.myVar# (CFML Standard)
				<br>
				<sub>Values: Boolean <code> true | false </code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Scope &raquo; Search resultset
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">//Application.cfc<br>this.searchResults = true;</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_TYPE_CHECKING<br>lucee.type.checking</div>
			</td>
			<td>
				Enables/disables type definitions checking with function arguments and return values
				<br><sub>Values: Boolean <code>true|false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Performance/Caching &raquo; UDF Type Checking
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  <pre lang="html">//Application.cfc<br>this.typeChecking = true; </pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_STATUS_CODE<br>lucee.status.code</div>
			</td>
			<td>
				Enables/disables sending 200 http status code in case of an exception.
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Error &raquo; Status code
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_S3_SECRETKEY<br>lucee.s3.secretkey<br>
					<br>
					LUCEE_S3_ACCESSKEYID<br>lucee.s3.accesskeyid
				</div>
			</td>
			<td>
				Defines the S3 virtual S3 bucket mapping credentials. Use this to hide AWS S3 credentials from source code or Web Administrator. That way you connect to your S3 bucket with a <code>S3:///myAwsBucketname/someDirectory/</code> <code>S3:///myAwsKey:myAwsSecretKey@/myAwsBucketname/someDirectory/</code>. Please see [[category-s3]]
				<br><sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">//Application.cfc<br>this.s3.accesskeyid = "myAWSaccessID";<br>this.s3.awssecretkey = "myAWSsecretKey";</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_UPLOAD_BLOCKLIST<br>lucee.upload.blocklist<br>
				</div>
			</td>
			<td>
				Defines a comma separeted list of file extensions that are not allowed to be uploaded. By default Lucee will block a set of files that have potential risk. Use this setting to have more control over Lucees default settings.
				<br><sub>Values: String</sub>
				<p>
					<strong>Example:</strong> The following directive won't allow the upload of the following files:
					<pre lang="script">LUCEE_UPLOAD_BLOCKLIST=asp,aspx,cfc,cfm,cfml,do,htm,html,jsp,jspx,php</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
					<pre lang="html">//Application.cfc<br>this.blockedExtForFileUpload="asp,aspx,cfc,cfm,cfml,do,htm,html,jsp,jspx,php"
					</pre>
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_BASE_DIR<br>lucee.base.dir
				</div>
			</td>
			<td>
				Defines the base directory location for the server engine.
				<br><sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_SERVER_DIR<br>lucee.server.dir
				</div>
			</td>
			<td>
				Defines the directory location where Lucee should create the server context. 
				
				By default Lucee places its server context in the servlet engines directory. 
				
				Use this to move the server context outside. This directive is the same as the init param lucee-server-directory of <code><em>path-to-lucee-installation\tomcat\conf\web.xml</em></code>
				<br><sub>Values: String</sub>
				<p>
					<strong>Example:</strong> Moving web contexts to another location:
					<pre lang="script">set "LUCEE_SERVER_DIR="/var/another-location/server/"</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_WEB_DIR<br>lucee.web.dir
				</div>
			</td>
			<td>
				Defines the directory location where Lucee should create the web contexts. 
				
				<p>By default Lucee places its web-context configuration and data files in a folder named WEB-INF within the webroot of each website. Use this to move the web context outside of the websites webroot. </p>
				
				<p>This directive is the same as the init param lucee-web-directory of <code><em>path-to-lucee-installation\tomcat\conf\web.xml</em></code>. </p>
				
				When using this directive you'll need to add Lucees label variable <code>{web-context-label}</code> to the path that will be used as the identifier hash or label for the created web contexts.
				<br><sub>Values: String</sub>
				<p>
					<strong>Example:</strong> Moving web contexts to another location:
					<pre lang="script">set "LUCEE_WEB_DIR="/var/another-location/web/{web-context-label}/"</pre>
				</p>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_ENABLE_DIALECT<br>lucee.enable.dialect
				</div>
			</td>
			<td>
				Enables/disables the experimental Lucee dialect
				<br><sub>Values: String</sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_FELIX_LOG_LEVEL<br>lucee.felix.log.level
				</div>
			</td>
			<td>
				Sets log level for Felix
				<br><sub>Values: String <code>error | warning |info | debug</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_CONTROLLER_DISABLED<br>lucee.controller.disabled
				</div>
			</td>
			<td>
				Disables the controller. The Controller is an internal background process which runs maintenance tasks.  Default is <code>false</code>.<br>

				<strong>On Startup</strong><br>
				<ul>
					<li>Syncing NTP time</li>
					<li>Clearing out temp files</li>
					<li>Clearing out cache files</li>
					<li>Clearing out expired scopes like sessions (in persistent storage)</li>
				</ul>

				<strong>Every Minute</strong><br>
				<ul>
					<li>Automatically deploying updates / extensions [[deploying-lucee-server-apps]]
					<li>Clearing out unused DB connections</li>
					<li>Clearing out expired scopes like sessions</li>
					<li>Clearing out pagePools</li>
					<li>Checking mappings</li>
					<li>Clearing out mail server connections</li>
					<li>Clearing out locks</li>
					<li>Picking up changed configuration files</li>
				</ul>

				<strong>Every Hour</strong><br>
				<ul>
					<li>Syncing NTP time</li>
					<li>Clearing out temp files</li>
					<li>Clearing out cache files</li>
				</ul>

				<sub>Values: Boolean <code> true | false </code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">
					LUCEE_CONTROLLER_INTERVALL<br>lucee.controller.intervall
				</div>
			</td>
			<td>
				Number of milliseconds between controller calls.

				<br>Set to 0 to disable controller. Useful for benchmark testing.

				<br><sub>Values: Numeric</sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong>
					<br>
				  not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_LISTENER_TYPE<br>lucee.listener.type</div>
			</td>
			<td>
				Sets how requests are handled and which templates are invoked by default.<br>
				<ul>
					<li><strong>None</strong>: When a request is called no other initialization template will be invoked by Lucee.</li>
					<li><strong>classic</strong>: Classic handling (CFML < 7). Lucee looks for the file <code>Application.cfm</code> and a corresponding file <code>OnRequestEnd.cfm</code></li>
					<li><strong>modern</strong>: Modern handling. Lucee only looks for the file <code>Application.cfc</code></li>
					<li><strong>mixed</strong>: Mixed handling. Lucee looks for a file <code>Application.cfm / OnRequestEnd.cfm</code> as well as for the file <code>Application.cfc</code></li>
				</ul>

				<sub>Values: String <code>none | classic |modern |mixed </code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					Settings &raquo;  Request &raquo; Application listener &raquo; Type
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_LISTENER_MODE<br>lucee.listener.mode</div>
			</td>
			<td>
				Defines where Lucee looks for the files <code>Application.cfc / Application.cfm</code>. Note: In case of having LUCEE_LISTENER_TYPE set to <code>none</code> the setting for LUCEE_LISTENER_MODE is ignored.
				<ul>
					<li><strong>none</strong>: Looks for the file <code>Application.cfc / Application.cfm</code> from the current up to the <strong>curr2root</strong>: 
					Looks for the file <code>Application.cfc / Application.cfm</code> from the current up to the webroot directory.</li>
					<li><strong>currOrRoot</strong>: Looks for the file <code>Application.cfc / Application.cfm</code> in the current directory and in the webroot directory.</li>
					<li><strong>root</strong>: Looks for the file <code>Application.cfc / Application.cfm</code> only in the webroot .</li>
					<li><strong>curr</strong>: Looks for the file <code>Application.cfc / Application.cfm</code> only in the current template directory.</li>
				</ul>

				<sub>Values: String <code>none | curr2root | currOrRoot | root | curr</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong>
					<br>
					 Settings &raquo;  Request &raquo; Application listener &raquo; Mode
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_QOQ_HSQLDB_DISABLE<br>lucee.qoq.hsqldb.disable</div>
			</td>
			<td>
				Throw exception if native QoQ logic fails, otherwise Lucee falls back to using HSQLDB (which is needed for joins etc), Default is <code>false</code>.<br>

				[[http://wwvv.codersrevolution.com/blog/improving-lucees-query-of-query-support]]
				<br>
				<sub>Values: Boolean <code>true | false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>

		<tr>
			<td>
				<div class="attribute">LUCEE_QOQ_HSQLDB_DEBUG<br>lucee.qoq.hsqldb.debug</div>
			</td>
			<td>
				Log message to WEB context's datasource log any time a QoQ "falls back" to HyperSQL. This could include just bad SQL syntax. Default is <code>false</code>.<br>
				<sub>Values: Boolean <code>true|false</code></sub>
				<p>
					<strong>Lucee Server Administrator:</strong> not available
				</p>
				<p>
					<strong>Application.cfc:</strong> not available
				</p>
			</td>
		</tr>
		
	</tbody>
</table>
</div>
