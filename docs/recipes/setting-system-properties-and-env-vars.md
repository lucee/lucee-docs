<!--
{
  "title": "Setting System Properties and Environment Variables",
  "id": "running-lucee-system-properties",
  "description": "How to set and use Environment Variables or System Properties to configure specific Lucee Server settings.",
  "keywords": [
    "Environment",
    "Environment Variables",
    "Properties",
    "System Properties",
    "setting",
    "config"
  ],
  "categories": [
    "server"
  ],
  "related": [
	"tag-application"
  ]
}
-->

## Setting System Properties and Environment Variables ##

This documentation shows how to set and use *Environment Variables* or *System Properties* to configure specific Lucee Server settings.

Refer to [[environment-variables-system-properties]] for the full list of available settings.

### 1. Introduction ###

Lucee settings are usually configured manually within the Server Administrator for server-context  or in Web Administrator for web-context.

While settings for web-context are also configurable through your web applications Application.cfc (see [[tag-application]]), specific server-context settings can be configured with *Environment Variables* or *System Properties* (since Lucee 5.3).

This allows Administrators and Developers power to tweak server settings from startup without having to configure in the Server Administrators web interface.

For example, pre-define the extensions to be installed, enable full null support or define charsets for your running Lucee server instance.

### 2. Naming Notation ###

On startup Lucee identifies specific *Environment Variables* or JVM *System Properties* and uses them for the server setting configuration.

While system environment variable names need to be notated as *MACRO_CASE*, system property names need to be in *dot.notation*.

See as an example of variable/property name notation for enabling full null support in the table below:
<div class="table-responsive">
	<table>
		<thead>
			<tr>
				<th>Use as </th>
				<th>Notation Example </th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Environment Variables </td>
				<td><code>LUCEE_FULL_NULL_SUPPORT=true</code> <em>(MACRO_CASE)</em> </td>
			</tr>
			<tr>
				<td>System Properties </td>
				<td><code>lucee.full.null.support=true</code> <em>(dot.notation)</em> </td>
			</tr>
		</tbody>
	</table>
</div>

### 3. Setting The Variables ###

There are many different ways to make *Environment Variables* or *System Properties* available to Lucee depending on how you're running the Lucee server instance.

### 3.1 How To Set Environment Variables ###

Find below a brief overview of available options about where and how to set your *Environment Variables*:
<div class="table-responsive">
	<table>
		<thead>
			<tr>
				<th>Where </th>
				<th>Variables availability</th>
				<th>How to configure </th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>OS (globally)</td>
				<td>OS (system-wide)</td>
				<td>Environment variables are configured within your OS configuration. Please refer to the documentation of your OS </td>
			</tr>
			<tr>
				<td>OS (user specific) </td>
				<td>OS (system-wide), but limited to user </td>
				<td>Environment variables are configured within the OS user's profile configuration. Please refer to the documentation of your OS </td>
			</tr>
			<tr>
				<td>Servlet Engine Tomcat </td>
				<td>Limited to the running servlet instance </td>
				<td><strong>Option I:</strong> Use Tomcats <em>path-to-lucee-installation\tomcat\bin\setenv.bat (Windows) or path-to-lucee-installation\tomcat\bin\setenv.sh (Linux)</em> as specified in <a href="https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt">Tomcats 9.0 Documentation (see 3.4)</a><br> <strong>Option II:</strong> Run Tomcat with the argument <em>--Environment=key1=value1;key2=...</em> as specified in <a href="https://tomcat.apache.org/tomcat-9.0-doc/windows-service-howto.html">Tomcat 9 parameters</a> </td>
			</tr>
			<tr>
				<td>CommandBox </td>
				<td>Limited to the running CommandBox instance </td>
				<td>Since CommandBox 4.5 <em>Environment Variables</em> can be set in a file named ".env". You can easily create the .env file by running the command <code>dotenv set</code> from your CommandBox CLI. For more information please see <a href="https://github.com/commandbox-modules/commandbox-dotenv">How to set it up CommandBox with .env files</a> and <a href="https://commandbox.ortusbooks.com/usage/environment-variables">CommandBox Environment Variables</a> </td>
			</tr>
		</tbody>
	</table>
</div>

In the following example we'll follow Tomcat's recommendation and set *Environment Variables* by using Tomcats setenv.bat/setenv.sh files.

**For Windows:** Create a batch file at  *path-to-lucee-installation\tomcat\bin\setenv.bat* with the following content:

```bat
REM Keep all struct keys defined with "dot notation" in original case.
set "LUCEE_PRESERVE_CASE=true"

REM Enable full null support
set "LUCEE_FULL_NULL_SUPPORT=true"

REM Set Simple whitespace management
set "LUCEE_CFML_WRITER=white-space"
```

If you have installed **Tomcat as service in Windows**, the service wrapper launches Java directly without using script files.

In this case you can alternatively add the *Environment Variables* by running the following Tomcat service update command in a terminal window:
`path-to-lucee-installation\tomcat\bin\tomcat9.exe //US//NameOfYourTomcatService --Environment=key1=value1;key2=...`

**For Linux:** Create a shell script at  *path-to-lucee-installation\tomcat\bin\setenv.sh* with the following content:

```bash
# Keep all struct keys defined with "dot notation" in original case.
LUCEE_PRESERVE_CASE=true

# Enable full null support
LUCEE_FULL_NULL_SUPPORT=true

# Set Simple whitespace management
LUCEE_CFML_WRITER=white-space
```

**Important**: *When creating batch/shell script files for Tomcat, please make sure their permissions are correctly set for the user running Tomcat to read and execute them.*

### 3.2 How To Set System Properties ###

System Properties are specific to the JVM servlet container engine.

Just like Environment Variables they can be configured at different locations.

In this example we will focus on configuring *System Properties* when running Lucee with Tomcat or  CommandBox.

Here is a brief overview.

<div class="table-responsive">
	<table>
		<thead>
			<tr>
				<th>Configuration for </th>
				<th>How to configure </th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Servlet Engine Tomcat </td>
				<td>Use Tomcats <em>path-to-lucee-installation\tomcat\bin\setenv.bat or path-to-lucee-installation\tomcat\bin\setenv.sh</em> and add the system property using <code>CATALINA_OPTS</code>. See <a href="https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt">Tomcats 9.0 Documentation (see 3.3)</a> </td>
			</tr>
			<tr>
				<td>CommandBox </td>
				<td>In CommandBox <em>System Properties</em> can be set like Environment Variables in the <code>.env</code> file. </td>
			</tr>
		</tbody>
	</table>
</div>

In Tomcat *System Properties* are passed to the JVM servlet engine Tomcat on startup by populating CATALINA_OPTS with the -D flag, e.g. `-Dlucee.full.null.support=true` (note that there is no space between the -D flag and the system property key/value).

With Tomcat it's recommended to set CATALINA_OPTS in the setenv.bat/setenv.sh file.

**For Windows:** Create a batch file at  *path-to-lucee-installation\tomcat\bin\setenv.bat* with the following content:

```bat
REM Set System Properties with CATALINA_OPTS
set "CATALINA_OPTS=-Dlucee.full.null.support=true -Dlucee.cfml.writer=white-space -Dlucee.cfml.writer=white-space"
```

If you have installed **Tomcat as service in Windows**, the service wrapper launches Java directly without using script files.

In this case you can alternatively add the *System Properties* in the JAVA tab of Tomcats GUI service editor.

To launch Tomcat GUI service editor, open a terminal window and enter `path-to-lucee-installation\tomcat\bin\tomcat9w.exe //ES//NameOfYourTomcatService`.

**For Linux:** Create a shell script at  *path-to-lucee-installation\tomcat\bin\setenv.sh* with the following content:

```bash
# Set System Properties with CATALINA_OPTS
CATALINA_OPTS=-Dlucee.full.null.support=true -Dlucee.cfml.writer=white-space -Dlucee.cfml.writer=white-space
```

**Important**: *When creating batch/shell script files for Tomcat, please make sure their permissions are correctly set for the user running Tomcat to read and execute them.*

If you are running Lucee with **CommandBox**, you can make use of *System Properties* by saving them to the `.env` file, just the same way it's done with *Environment Variables*.

For further information please see [How to set it up CommandBox with .env files](https://github.com/commandbox-modules/commandbox-dotenv) and [CommandBox Environment Variables](https://commandbox.ortusbooks.com/usage/environment-variables).

### 5. Verifying Variables/Properties Passed To Lucee ###

To make sure the *Environment Variables/System Properties* are properly being passed to Tomcat/Lucee, you can simply dump these variables from within your web application with cfml as follows:

```cfml
<cfscript>
writeDump(server.system.environment);
writeDump(server.system.properties);
</cfscript>
```

### 6. Security Considerations ###

When using *Environment Variables* or *System Properties* you need to consider important security implications.

This is because the data stored in this sort of variables or files may be accessible by other users sharing the same OS or running servlet engine instance.

Storing sensitive information e.g. hashed passwords, access-tokens, user names, database names, etc on OS or files has to be considered very carefully.

Also, make sure not to publish these files with sensitive data as part of open source code in public repositories.
