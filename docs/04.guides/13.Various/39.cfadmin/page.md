---
title: CFAdmin documentation
id: cfadmin-docs
---

Since several people asked us to document the CFAdmin tag, we are publishing it here already so that you can have a look at all the actions and attributes as well as the examples available.

### General information ###

The tag <cfadmin> is used for all changes one wants to do in the Lucee configuration. Depending on what value for the attribute type you pass (web|server) either the local web configuration is changed or the global server one. Please note that the password provided needs to be the corresponding one. Whether you have to pass the password to the <cfadmin> tag depends on the setting you made in the server administrator under access / general access. If you have set this option to open for the current web admin you do not have to provide the password. If it is password protected, you need to add the password, if it is closed, the access is prohibited.
So normally the basic three attributes for the tag <cfadmin> are action, type and password. Below you will find a list with all possible attributes for the tag <cfadmin>:

Attribute name | Description
-------------- | -----------------
 _ type | Application type for installable Lucee extensions
access_read |	Defines the general access to the Lucee configuration read
access_write |	Defines the general access to the Lucee configuration write
allowed_alter |	Database connection property
allowed_create | Database connection property
allowed_delete | Database connection property
allowed_drop |	Database connection property
allowed_grant |	Database connection property
allowed_insert | Database connection property
allowed_revoke | Database connection property
allowed_select | Database connection property
allowed_update | Database connection property
allowImplicidQueryCall | Defines whether the query names must be provided (scoping)
AllowURLRequestTimeout | Defines whether a requesttimeout is allowed as an url variable
append | Sets whether a compiled archive should be associated with a mapping
applicationTimeout | Defines the application timeout
archive | Defines the archive that is used for a mapping
author | Contains the author of an extension
baseComponentTemplate |	Contains the basic component template
blob | Defines whether clob is usable with this data source
category | Contains the category of an extension
cfx_setting | Defines whether a user can access the cfx settings in the local web administrator
cfx_usage |	Allows the usage of CFX tags in Lucee for this particular web
class |	Defines the name of a class for a Java CFX tag
classname |	Defines the name of the database driver class
clientCookies |	Defines whether client cookies are allowed or not
clientManagement |	Enables client management
clob |	Defines whether clob is usable with this data source
codename |	Contains the codename of an extension
collection | Contains the collection name
collectionAction |	Subaction for the action collection. Allowed are create repair, optimize, delete
componentDataMemberDefaultAccess |	Defines the visibility of the components' this scope valid values are: private, protected, public, remote
componentDumpTemplate |	Sets the path to the template that is used when a component gets dumped out
config | Contains the path to the configuration file for an extension
connectionLimit | Database connection property
connectionTimeout | Database connection property
contextPath | Contains the path to the web context for the action "resetPassword"
created | Contains the creation date of an extension
custom | Contains any custom JDBC properties for the connection string to the defined data source
custom_tag | Defines whether a user has the right to change the custom tag settings in the local web administrator
Database | Database connection property
Datasource | Database connection property
Dbpassword | Database connection property
dbusername | Database connection property
debug | Enables or disables debugging or sets it to the server property
debugging | Defines whether a user has the right to change the debugging settings in the local web administrator
debugTemplate | Contains the path to the debugging template to be used
deepSearch | Defines whether custom tags are searched in subfolders of the custom tag directories recursively or not.
defaultEncoding | Defines the default encoding of the local Lucee context
description | Extension description
direct_java_access | Defines whether direct Java invocation can be used in a local web context
documentation | Contains the link to the Extensions documentation
domaincookies | Sets whether domain cookies are allowed or not
dsn | Defines the dsn for a data source
enddate | Defines the end date for a scheduled task
endtime | Defines the end time for a scheduled task
extensions | Contains the extensions for the documents to be indexed
file | Defines whether files can be accessed in and below the web root, on the complete server or whether access to files is prohibited in the local web context
forum | Contains the link to the Extensions forum
host | Contains the host of a database server in a data source definition
hostname | Contains the hostname of a mail server
id | Contains the id of an extension
image | Contains the image of the extension
indexAction | Sub action for the action index. Allowed values are: "update, purge"
indexType | Type of the index. Allowed values are: "path, url"
interval | Defines the interval of a scheduled task
key | Contains the key of a plugin storage item
label | Contains the label of an extension
language | Defines the language of an index
listenerMode | Defines the listener mode of Lucee which defines where Lucee searches for auto include files
listenerType | Defines the listener type of Lucee which defines what files are invoked. Application.cfc/.cfm, OnRequestEnd.cfm
locale | Defines the regional local for the current web context
localMode | Defines whether undefined variables are in the local scope inside functions and methods or in the variables scope.
localSearch | Defines whether Lucee searches in the local (current) directory for a custom tag or not
logfile | Defines the log file for the mail settings
loglevel | Defines the log level for the mail settings
mail | Defines whether users have access to the mail settings in the local web administrators
mailinglist | Contains the link to the Extensions mailing list
mailpassword | Contains the password for the mailserver
mailusername | Contains the username for the mailserver
mapping | Defines whether users have access to the mapping settings in the local web administrators
mergeFormAndUrl | Defines whether the url and form scope are merged in a request
name | Defines the name of the JavaCFX Tag, Defines the name of a data source definition, Contains the name of an extension |
network | Contains the link to the network of the extension
newPassword | Contains the new password for the action "updatePassword"
oldPassword | Contains the old password for the action "updatePassword"
Operation | |
Password | Depending on the value of the attribute type and the setting of the general access, this attribute must contain the web or server administrator password.
Path |	Contains the path for the collection
Physical |	Contains the path to the physical location for a mapping (can be a resource as well)
Port |	Defines the port of the mail server
primary | Defines whether the physical location or the archive is used as the primary location for the search for a template
provider |	url of the extension provider
proxyEnabled |	Defines whether the proxy server will be used
proxyPassword |	Contains the proxy password
proxyPort |	Contains the proxy port
proxyServer |	Contains the proxy server name or ip
proxyuser |	Contains the proxy username
proxyUsername |	Contains the proxy username
psq | Defines whether preserve single quotes is turned on for this web context
publish | Defines whether the response of server will be stored in a file or not
recurse | Defines whether a path will be recursively indexed
remote | Defines whether a local user can change the settings in the remote section of the local web administrator
remoteClients | Every tag can contain remote clients to synchronize its settings with. It is a list of labels of in the admin defined remote clients
remotetype | Defines whether it’s an admin synchronization or cluster scope sharing
requestTimeout | Defines the time a scheduled task should wait before it stops the thread. Please note that this setting does not set the request timeout of the server, unless it is a Lucee server and you allow passing "requesttimeout" over the url
resolveurl | Defines whether a scheduled task should resolve relative urls in the output.
resourceCharset | Defines the charset of Lucee resources
returnVariable | Contains the returned data from several actions (around 50 or so). The return type is not clear. It depends on the used context.
scheduleAction | Subaction for the action schedule. Allowed values are: "run, delete, pause, resume, update"
scheduled_task | Defines whether a local user can change the settings in the scheduled tasks section of the local web administrator
schedulePassword | Password to access the URL protected by authentication
scopeCascadingType | Defines whether the scope cascading is set to off or other values. Valid values are: "strict,small,standard"
scriptProtect |	Defines the scopes that shall be searched for cross site scripting. Valid values are a combination of "cgi, cookie, form, url"
search | Defines whether a local user can change the settings in the search section of the local web administrator
secType | Defines the type of security manager setting you want to retrieve. Valid values are: "search, mail, datasource, setting, debugging, remote, mapping, cfx_setting, cfx_usage, custom_tag, "
secure | Defines whether a mapping is compiled in the secure mode (without the source code) or insecure (containing the source code). Depending on this setting the extension is either .ras (secure) or .ra
secValue | |
Serverpassword | Password of the server admin (sometimes necessary in order to have access to files like debugging templates if file access is set to none etc.)
sessionManagement | Enables session management in scope settings
sessionTimeout | Defines the session timeout for the local web context
sessionType | Defines whether CFML or J2EE sessions are to be used in the local web context
setting |
showVersion | Defines whether the response header contains the Lucee version
spoolEnable | Defines whether mail spooling is enabled
spoolInterval |	Defines the mail spooling interval
ssl | Defines whether ssl is used in the mail server settings
startdate |	Defines the start date of a scheduled task
starttime |	Defines the start time of a scheduled task
statuscode | Defines whether in case of an error Lucee sends the actual error status code back or 200
stoponerror | Defines whether Lucee stops on the first compile error when compiling a mapping
support | Contains the support link of an extension
supressWhiteSpace |	Defines whether whitespaces should be suppressed on every request
tag_execute | Defines whether the tag execute can be allowed or not
tag_import | Defines whether the tag import can be allowed or not
tag_object | Defines whether the tag object can be allowed or not
tag_registry |	Defines whether the tag registry can be allowed or not
task |	Contains the defined schedule task when the action is "schedule"
template404 | Defines the path to the 404 template
template500	| Defines the path to the 50x template
templateCharset	| Contains the template of Lucee charsets
timeout | Contains the timeout of the mailserver
timeserver | Contains the url to the time server
timezone |	Defines the time zone for this local web context
tls	| Defines whether tsl is used in the mail server settings
toplevel | Defines whether a mapping is a top level mapping. If yes it can be called over the URL
triggerDataMember |	Enables magic functions
trusted	| Defines whether a mapping or a custom tag path is trusted or not
type |	Contains one of "web, server" depending on which setting is changed
updateLocation | Defines the update url to retrieve Lucee patches from
updateType | Defines how updates are executed
url	| Contains the url of a remote client, Contains the url of a scheduled task
urlpath | Contains the path to the corresponding url when action is index
username | Contains the username for a scheduled task if the url needs authentication
useShadow |	Defines whether the local variables scope in Lucee exists or not. If you set the "this" scope to be private in components, this setting makes perfect sense.
value |	Contains the value to be stored with the action "storageSet"
version | Contains the version of an extension
video |	Contains the video of the extension
virtual | Defines the virtual name of a mapping
webCharset | Defines the charset of the response stream

Action | Description
---------|-----------
collection | Handles Lucene collections
compileMapping | Compiles a mapping
connect | Tries to log in into the administrator
createArchive |	Creates an archive
createSecurityManager |	Creates security settings for a new, selected web context
defaultSecurityManager | Changes settings fort he default web contexts
executeSpoolerTask | Executes a background task
getApplicationListener | Gets the application listener, stores it in the attribute returnvariable
getApplicationSetting |	Returns the settings of the application settings for the current context
getCharset | Returns the settings of the current context charstets
getComponent | Returns the settings of the component settings for the current context
getContextes | Returns the current web contexts (only available for the server type)
getCustomTagMappings | |
getCustomtagSetting | Returns the settings of the custom tags for the current context
getDatasource |	Returns the details for a datasource for the current context
getDatasourceDriverList	| Returns the list of all datasource drivers for the current context
getDatasources | Returns the datasources for the current context
getDatasourceSetting | Returns the settings for a datasource for the current context
getDebug | |
getDebugData | |
getDebuggingList | |
getDefaultPassword | |
getDefaultSecurityManager | |
getError | |
getErrorList | |
getExtensionInfo | |
getExtensionProviders | |
getExtensions | |
getFLDs | |
getJavaCFXTags | |
getLocales | |
getMailServers | |
getMailSetting | |
getMappings | |
getOutputSetting | |
getPluginDirectory | |
getProxy | |
getRegional | |
getRemoteClient | |
getRemoteClients | |
getRemoteClientUsage | |
getScope | |
getSecurityManager | |
getSpoolerTasks | |
getTimeZones | |
getTLDs | |
getUpdate | |
hasPassword | |
index | |
removeCFX | |
removeCustomTag | |
removeDatasource | |
removeDefaultPassword | |
removeExtension | |
removeMailServer | |
removeMapping | |
removeProxy | |
removeRemoteClient | |
removeSecurityManager | |
removeSpoolerTask | |
removeUpdate | |
resetId | |
resetPassword | |
restart | |
runUpdate | |
schedule | |
securityManager | |
storageGet | |
storageSet | |
updateApplicationListener | |
updateApplicationSetting | |
updateCharset | |
updateComponent | |
updateCustomTag | |
updateCustomTagSetting | |
updateDatasource | |
updateDebug | |
updateDefaultPassword | |
updateDefaultSecurity | |
updateDefaultSecurityManager | |
updateError | |
updateExtension | |
updateJavaCFX | |
updateMailServer | |
updateMailSetting | |
updateMapping | |
updateOutputSetting | |
updatePassword | |
updateProxy | |
updatePSQ | |
updateRegional | |
updateRemoteClient | |
updateScope | |
updateSecurityManager | |
UpdateUpdate | |
verifyDatasource | |
verifyJavaCFX | |
verifyMailServer | |
verifyRemoteClient | |

Below you will find all the actions sorted alphabetically embedded in examples for them:

	<cfadmin
	    action="collection"
	    type="web|server"
	    password="password"
	    collectionAction="create"
	    collection="#form.collName#"
	    path="#form.collPath#"
	    language="#form.collLanguage#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="collection"
	    type="web|server"
	    password="password"
	    collectionAction="delete"
	    collection="#form.name[key]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="collection"
	    type="web|server"
	    password="password"
	    collectionAction="optimize"
	    collection="#form.name[key]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="collection"
	    type="web|server"
	    password="password"
	    collectionAction="repair"
	    collection="#form.name[key]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="compileMapping"
	    type="web|server"
	    password="password"
	    virtual="#data.virtuals[idx]#"
	    stoponerror="#data.stoponerrors[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="connect"
	    type="web|server"
	    password="password">

	<cfadmin
	    action="createArchive"
	    type="web|server"
	    password="password"
	    file="#target#"
	    virtual="#data.virtuals[idx]#"
	    secure="#data.secure[idx]#"
	    append="#notdoDownload#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="createSecurityManager"
	    type="web|server"
	    password="password"
	    id="#form.id#">

	<cfadmin
	    action="defaultSecurityManager"
	    type="web|server"
	    password="password"
	    returnVariable="access">

	<cfadmin
	    action="executeSpoolerTask"
	    type="web|server"
	    password="password"
	    id="#data.ids[idx]#">

	<cfadmin
	    action="getApplicationListener"
	    type="web|server"
	    password="password"
	    returnVariable="listener">

	<cfadmin
	    action="getApplicationSetting"
	    type="web|server"
	    password="password"
	    returnVariable="appSettings">

	<cfadmin
	    action="getCharset"
	    type="web|server"
	    password="password"
	    returnVariable="charset">

	<cfadmin
	    action="getComponent"
	    type="web|server"
	    password="password"
	    returnVariable="component">

	<cfadmin
	    action="getContextes"
	    type="web|server"
	    password="password"
	    returnVariable="contextes">

	<cfadmin
	    action="getCustomTagMappings"
	    type="web|server"
	    password="password"
	    returnVariable="mappings">

	<cfadmin
	    action="getCustomtagSetting"
	    type="web|server"
	    password="password"
	    returnVariable="setting">

	<cfadmin
	    action="getDatasource"
	    type="web|server"
	    password="password"
	    name="#form.name#"
	    returnVariable="existing">

	<cfadmin
	    action="getDatasourceDriverList"
	    type="web|server"
	    password="password"
	    returnVariable="dbdriver">

	<cfadmin
	    action="getDatasourceSetting"
	    type="web|server"
	    password="password"
	    returnVariable="dbSetting">

	<cfadmin
	    action="getDebug"
	    type="web|server"
	    password="password"
	    returnVariable="debug">

	<cfadmin
	    action="getDebugData"
	    returnVariable="debugging">

	<cfadmin
	    action="getDebuggingList"
	    type="web|server"
	    password="password"
	    returnVariable="debug_templates">

	<cfadmin
	    action="getDefaultPassword"
	    type="web|server"
	    password="password"
	    returnVariable="defaultPassword">

	<cfadmin
	    action="getDefaultSecurityManager"
	    type="web|server"
	    password="password"
	    returnVariable="access">

	<cfadmin
	    action="getError"
	    type="web|server"
	    password="password"
	    returnVariable="err">

	<cfadmin
	    action="getErrorList"
	    type="web|server"
	    password="password"
	    returnVariable="err_templates">

	<cfadmin
	    action="getExtensionInfo"
	    type="web|server"
	    password="password"
	    returnVariable="info">

	<cfadmin
	    action="getExtensionProviders"
	    type="web|server"
	    password="password"
	    returnVariable="providers">

	<cfadmin
	    action="getExtensions"
	    type="web|server"
	    password="password"
	    returnVariable="extensions">

	<cfadmin
	    action="getFLDs"
	    type="web|server"
	    password="password"
	    returnVariable="flds">

	<cfadmin
	    action="getJavaCFXTags"
	    type="web|server"
	    password="password"
	    returnVariable="jtags">

	<cfadmin
	    action="getLocales"
	    locale="#stText.locale#"
	    returnVariable="locales">

	<cfadmin
	    action="getMailServers"
	    type="web|server"
	    password="password"
	    returnVariable="ms">

	<cfadmin
	    action="getMailSetting"
	    type="web|server"
	    password="password"
	    returnVariable="mail">

	<cfadmin
	    action="getMappings"
	    type="web|server"
	    password="password"
	    returnVariable="mappings">

	<cfadmin
	    action="getOutputSetting"
	    type="web|server"
	    password="password"
	    returnVariable="setting">

	<cfadmin
	    action="getPluginDirectory"
	    type="web|server"
	    password="password"
	    returnVariable="pluginDir">

	<cfadmin
	    action="getProxy"
	    type="web|server"
	    password="password"
	    returnVariable="proxy">

	<cfadmin
	    action="getRegional"
	    type="web|server"
	    password="password"
	    returnVariable="regional">

	<cfadmin
	    action="getRemoteClient"
	    type="web|server"
	    password="password"
	    url="#data.urls[idx]#"
	    returnVariable="rclient">

	<cfadmin
	    action="getRemoteClients"
	    type="web|server"
	    password="password"
	    returnVariable="clients">

	<cfadmin
	    action="getRemoteClientUsage"
	    type="web|server"
	    password="password"
	    returnVariable="usage">

	<cfadmin
	    action="getScope"
	    type="web|server"
	    password="password"
	    returnVariable="scope">

	<cfadmin
	    action="getSecurityManager"
	    type="web|server"
	    password="password"
	    id="#url.id#"
	    returnVariable="access">

	<cfadmin
	    action="getSpoolerTasks"
	    type="web|server"
	    password="password"
	    returnVariable="tasks">

	<cfadmin
	    action="getTimeZones"
	    locale="#stText.locale#"
	    returnVariable="timezones">

	<cfadmin
	    action="getTLDs"
	    type="web|server"
	    password="password"
	    returnVariable="tlds">

	<cfadmin
	    action="getUpdate"
	    type="web|server"
	    password="password"
	    returnvariable="update">

	<cfadmin
	    action="getUpdate"
	    type="web|server"
	    password="password"
	    returnvariable="update">

	<cfadmin
	    action="hasPassword"
	    type="web|server"
	    returnVariable="hasPassword">

	<cfadmin
	    action="index"
	    type="web|server"
	    password="password"
	    indexAction="purge"
	    collection="#form.name[key]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="index"
	    type="web|server"
	    password="password"
	    indexAction="update"
	    indexType="path"
	    collection="#url.collection#"
	    key="#form.path#"
	    urlpath="#form.url#"
	    extensions="#form.extensions#"
	    recurse="#structKeyExists(form,"recurse")andform.recurse#"
	    language="#form.language#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="removeCFX"
	    type="web|server"
	    password="password"
	    name="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="removeCustomTag"
	    type="web|server"
	    password="password"
	    virtual="#data.virtuals[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="removeDatasource"
	    type="web|server"
	    password="password"
	    name="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="removeDefaultPassword"
	    type="web|server"
	    password="password">

	<cfadmin
	    action="removeExtension"
	    type="web|server"
	    password="password"
	    provider="#detail.installed.provider#"
	    id="#detail.installed.id#">

	<cfadmin
	    action="removeMapping"
	    type="web|server"
	    password="password"
	    virtual="#data.virtuals[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="removeProxy"
	    type="web|server"
	    password="password"
	    >

	<cfadmin
	    action="removeRemoteClient"
	    type="web|server"
	    password="password"
	    url="#data.urls[idx]#">

	<cfadmin
	    action="removeSecurityManager"
	    type="web|server"
	    password="password"
	    id="#data.ids[idx]#">

	<cfadmin
	    action="removeSpoolerTask"
	    type="web|server"
	    password="password"
	    id="#data.ids[idx]#">

	<cfadmin
	    action="removeUpdate"
	    type="web|server"
	    password="password"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="resetId"
	    type="web|server"
	    password="password">

	<cfadmin
	    action="resetPassword"
	    type="web|server"
	    password="password"
	    contextPath="#form.contextPath#">

	<cfadmin
	    action="restart"
	    type="web|server"
	    password="password"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="runUpdate"
	    type="web|server"
	    password="password">

	<cfadmin
	    action="schedule"
	    type="web|server"
	    password="password"
	    scheduleAction="delete"
	    task="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="schedule"
	    type="web|server"
	    password="password"
	    scheduleAction="pause"
	    task="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="schedule"
	    type="web|server"
	    password="password"
	    scheduleAction="resume"
	    task="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="schedule"
	    type="web|server"
	    password="password"
	    scheduleAction="run"
	    task="#data.names[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="schedule"
	    type="web|server"
	    password="password"
	    scheduleAction="update"
	    task="#form.name#"
	    url="#form.url#"
	    port="#form.port#"
	    requesttimeout="#form.timeout#"
	    username="#nullIfEmpty(form.username)#"
	    schedulePassword="#nullIfEmpty(form.password)#"
	    proxyserver="#nullIfEmpty(form.proxyserver)#"
	    proxyport="#form.proxyport#"
	    proxyuser="#nullIfEmpty(form.proxyuser)#"
	    proxypassword="#nullIfEmpty(form.proxypassword)#"
	    publish="#formBool('publish')#"
	    resolveurl="#formBool('resolveurl')#"
	    startdate="#nullIfNoDate('start')#"
	    starttime="#nullIfNoTime('start')#"
	    enddate="#nullIfNoDate('end')#"
	    endtime="#nullIfNoTime('end')#"
	    interval="#nullIfEmpty(form.interval)#"
	    file="#nullIfEmpty(form.file)#"
	    serverpassword="#variables.passwordserver#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="access"
	    secType="datasource">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="has.cfx_setting"
	    secType="cfx_setting"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="has.cfx_usage"
	    secType="cfx_usage"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="custom_tag"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="debugging"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="mail"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="mapping"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="remote"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="search"
	    secValue="yes">

	<cfadmin
	    action="securityManager"
	    type="web|server"
	    password="password"
	    returnVariable="hasAccess"
	    secType="setting"
	    secValue="yes">

	<cfadmin
	    action="storageGet"
	    type="web|server"
	    password="password"
	    key="#url.plugin#"
	    returnVariable="data">

	<cfadmin
	    action="storageSet"
	    type="web|server"
	    password="password"
	    key="#url.plugin#"
	    value="#data#">

	<cfadmin
	    action="updateApplicationListener"
	    type="web|server"
	    password="password"
	    listenerType="#form.type#"
	    listenerMode="#form.mode#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateApplicationSetting"
	    type="web|server"
	    password="password"
	    scriptProtect="#form.scriptProtect#"
	    AllowURLRequestTimeout="#structKeyExists(form,'AllowURLRequestTimeout')andform.AllowURLRequestTimeout#"
	    requestTimeout="#CreateTimeSpan(form.request_days,form.request_hours,form.request_minutes,form.request_seconds)#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateCharset"
	    type="web|server"
	    password="password"
	    templateCharset="#form.templateCharset#"
	    webCharset="#form.webCharset#"
	    resourceCharset="#form.resourceCharset#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateComponent"
	    type="web|server"
	    password="password"
	    baseComponentTemplate="#form.baseComponentTemplate#"
	    componentDumpTemplate="#form.componentDumpTemplate#"
	    componentDataMemberDefaultAccess="#form.componentDataMemberDefaultAccess#"
	    triggerDataMember="#isDefined('form.triggerDataMember')#"
	    useShadow="#isDefined('form.useShadow')#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateCustomTag"
	    type="web|server"
	    password="password"
	    virtual="#data.virtuals[idx]#"
	    physical="#data.physicals[idx]#"
	    archive="#data.archives[idx]#"
	    primary="#data.primaries[idx]#"
	    trusted="#data.trusteds[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateCustomTagSetting"
	    type="web|server"
	    password="password"
	    deepSearch="#isDefined('form.customTagDeepSearchDesc')andform.customTagDeepSearchDescEQtrue#"
	    localSearch="#isDefined('form.customTagLocalSearchDesc')andform.customTagLocalSearchDescEQtrue#"
	    extensions="#form.extensions#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateDatasource"
	    type="web|server"
	    password="password"
	    classname="#driver.getClass()#"
	    dsn="#driver.getDSN()#"
	    name="#form.name#"
	    host="#form.host#"
	    database="#form.database#"
	    port="#form.port#"
	    dbusername="#form.username#"
	    dbpassword="#form.password#"
	    connectionLimit="#form.connectionLimit#"
	    connectionTimeout="#form.connectionTimeout#"
	    blob="#getForm('blob',false)#"
	    clob="#getForm('clob',false)#"
	    allowed_select="#getForm('allowed_select',false)#"
	    allowed_insert="#getForm('allowed_insert',false)#"
	    allowed_update="#getForm('allowed_update',false)#"
	    allowed_delete="#getForm('allowed_delete',false)#"
	    allowed_alter="#getForm('allowed_alter',false)#"
	    allowed_drop="#getForm('allowed_drop',false)#"
	    allowed_revoke="#getForm('allowed_revoke',false)#"
	    allowed_create="#getForm('allowed_create',false)#"
	    allowed_grant="#getForm('allowed_grant',false)#"
	    custom="#custom#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateDebug"
	    type="web|server"
	    password="password"
	    debug="#form.debug#"
	    debugTemplate="#form["debugTemplate_"&form.debugtype]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateDefaultPassword"
	    type="web|server"
	    password="password"
	    newPassword="#form._new_password#">

	<cfadmin
	    action="updateDefaultSecurity"
	    type="web|server"
	    password="password"
	    setting="#fb('defaultSetting')#"
	    file="#form.defaultFile#"
	    direct_java_access="#fb('defaultDirectJavaAccess')#"
	    mail="#fb('defaultMail')#"
	    datasource="#fb('defaultDatasource')#"
	    mapping="#fb('defaultMapping')#"
	    custom_tag="#fb('defaultCustomTag')#"
	    cfx_setting="#fb('defaultCfxSetting')#"
	    cfx_usage="#fb('defaultCfxUsage')#"
	    debugging="#fb('defaultDebugging')#"
	    tag_execute="#fb('defaultTagExecute')#"
	    tag_import="#fb('defaultTagImport')#"
	    tag_object="#fb('defaultTagObject')#"
	    tag_registry="#fb('defaultTagRegistry')#">

	<cfadmin
	    action="updateDefaultSecurityManager"
	    type="web|server"
	    password="password"
	    setting="#fb('defaultSetting')#"
	    file="#form.defaultFile#"
	    direct_java_access="#fb('defaultDirectJavaAccess')#"
	    mail="#fb('defaultMail')#"
	    datasource="#form.defaultDatasource#"
	    mapping="#fb('defaultMapping')#"
	    remote="#fb('defaultRemote')#"
	    custom_tag="#fb('defaultCustomTag')#"
	    cfx_setting="#fb('defaultCfxSetting')#"
	    cfx_usage="#fb('defaultCfxUsage')#"
	    debugging="#fb('defaultDebugging')#"
	    search="#fb('defaultSearch')#"
	    scheduled_task="#fb('defaultScheduledTask')#"
	    tag_execute="#fb('defaultTagExecute')#"
	    tag_import="#fb('defaultTagImport')#"
	    tag_object="#fb('defaultTagObject')#"
	    tag_registry="#fb('defaultTagRegistry')#"
	    access_read="#form.defaultaccess_read#"
	    access_write="#form.defaultaccess_write#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateError"
	    type="web|server"
	    password="password"
	    template500="#form["errorTemplate_"&form.errtype500&500]#"
	    template404="#form["errorTemplate_"&form.errtype404&404]#"
	    statuscode="#isDefined('form.doStatusCode')#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateExtension"
	    type="web|server"
	    password="password"
	    config="#config#"
	    provider="#detail.url#"
	    id="#detail.app.id#"
	    version="#detail.app.version#"
	    name="#detail.app.name#"
	    label="#detail.app.label#"
	    description="#detail.app.description#"
	    category="#detail.app.category#"
	    image="#detail.app.image#"
	    author="#detail.app.author#"
	    codename="#detail.app.codename#"
	    video="#detail.app.video#"
	    support="#detail.app.support#"
	    documentation="#detail.app.documentation#"
	    forum="#detail.app.forum#"
	    mailinglist="#detail.app.mailinglist#"
	    network="#detail.app.network#"
	    created="#detail.app.created#">

	<cfadmin
	    action="updateJavaCFX"
	    type="web|server"
	    password="password"
	    name="#data.names[idx]#"
	    class="#data.classes[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateMailServer"
	    type="web|server"
	    password="password"
	    hostname="#data.hosts[idx]#"
	    dbusername="#data.usernames[idx]#"
	    dbpassword="#data.passwords[idx]#"
	    port="#data.ports[idx]#"
	    tls="#isDefined("data.tlss[#idx#]")anddata.tlss[idx]#"
	    ssl="#isDefined("data.ssls[#idx#]")anddata.ssls[idx]#"
	    remoteClients="arrayOfClients">
	    action="removeMailServer"
	    type="web|server"

	<cfadmin
	    action="updateMailSetting"
	    type="web|server"
	    password="password"
	    logfile="#form.logFile#"
	    loglevel="#form.loglevel#"
	    spoolEnable="#isDefined("form.spoolenable")andform.spoolenable#"
	    spoolInterval="#form.spoolInterval#"
	    timeout="#form.timeout#"
	    defaultEncoding="#form.defaultEncoding#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateMapping"
	    type="web|server"
	    password="password"
	    virtual="#data.virtuals[idx]#"
	    physical="#data.physicals[idx]#"
	    archive="#data.archives[idx]#"
	    primary="#data.primaries[idx]#"
	    trusted="#data.trusteds[idx]#"
	    toplevel="#data.toplevels[idx]#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateOutputSetting"
	    type="web|server"
	    password="password"
	    supressWhiteSpace="#isDefined('form.supressWhitespace')andform.supressWhitespace#"
	    showVersion="#isDefined('form.showVersion')andform.showVersion#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updatePassword"
	    type="web|server"
	    newPassword="#form.new_password#">

	<cfadmin
	    action="updateProxy"
	    type="web|server"
	    password="password"
	    proxyEnabled="true"
	    proxyServer="#proxy.server#"
	    proxyPort="#proxy.port#"
	    proxyUsername="#proxy.username#"
	    proxyPassword="#proxy.password#">

	<cfadmin
	    action="updatePSQ"
	    type="web|server"
	    password="password"
	    psq="#structKeyExists(form,"psq")andform.psq#">

	<cfadmin
	    action="updateRegional"
	    type="web|server"
	    password="password"
	    timezone="#form.timezone#"
	    locale="#form.locale#"
	    timeserver="#form.timeserver#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateRemoteClient"
	    type="web|server"
	    remotetype="web|server"
	    password="password"
	    attributeCollection="#attrColl#">

	<cfadmin
	    action="updateScope"
	    type="web|server"
	    password="password"
	    sessionType="#form.sessionType#"
	    localMode="#form.localMode#"
	    scopeCascadingType="#form.scopeCascadingType#"
	    allowImplicidQueryCall="#isDefined("form.allowImplicidQueryCall")andform.allowImplicidQueryCall#"
	    mergeFormAndUrl="#isDefined("form.mergeFormAndUrl")andform.mergeFormAndUrl#"
	    sessionTimeout="#CreateTimeSpan(form.session_days,form.session_hours,form.session_minutes,form.session_seconds)#"
	    applicationTimeout="#CreateTimeSpan(form.application_days,form.application_hours,form.application_minutes,form.application_seconds)#"
	    sessionManagement="#isDefined("form.sessionManagement")andform.sessionManagement#"
	    clientManagement="#isDefined("form.clientManagement")andform.clientManagement#"
	    clientCookies="#isDefined("form.clientCookies")andform.clientCookies#"
	    domaincookies="#isDefined("form.domaincookies")andform.domaincookies#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="updateSecurityManager"
	    type="web|server"
	    password="password"
	    id="#url.id#"
	    setting="#fb('defaultSetting')#"
	    file="#form.defaultFile#"
	    direct_java_access="#fb('defaultDirectJavaAccess')#"
	    mail="#fb('defaultMail')#"
	    datasource="#form.defaultDatasource#"
	    mapping="#fb('defaultMapping')#"
	    remote="#fb('defaultRemote')#"
	    custom_tag="#fb('defaultCustomTag')#"
	    cfx_setting="#fb('defaultCfxSetting')#"
	    cfx_usage="#fb('defaultCfxUsage')#"
	    debugging="#fb('defaultDebugging')#"
	    search="#fb('defaultSearch')#"
	    scheduled_task="#fb('defaultScheduledTask')#"
	    tag_execute="#fb('defaultTagExecute')#"
	    tag_import="#fb('defaultTagImport')#"
	    tag_object="#fb('defaultTagObject')#"
	    tag_registry="#fb('defaultTagRegistry')#"
	    access_read="#form.defaultaccess_read#"
	    access_write="#form.defaultaccess_write#">

	<cfadmin
	    action="UpdateUpdate"
	    type="web|server"
	    password="password"
	    updateType="#form.type#"
	    updateLocation="#form.location#"
	    remoteClients="arrayOfClients">

	<cfadmin
	    action="verifyDatasource"
	    type="web|server"
	    password="password"
	    name="#data.names[idx]#"
	    dbusername="#data.usernames[idx]#"
	    dbpassword="#data.passwords[idx]#">

	<cfadmin
	    action="verifyJavaCFX"
	    type="web|server"
	    password="password"
	    name="#data.names[idx]#"
	    class="#data.classes[idx]#">

	<cfadmin
	    action="verifyMailServer"
	    type="web|server"
	    password="password"
	    hostname="#data.hosts[idx]#"
	    port="#data.ports[idx]#"
	    mailusername="#data.usernames[idx]#"
	    mailpassword="#data.passwords[idx]#">

	<cfadmin
	    action="verifyRemoteClient"
	    type="web|server"
	    password="password"
	    attributeCollection="#rclient#">
