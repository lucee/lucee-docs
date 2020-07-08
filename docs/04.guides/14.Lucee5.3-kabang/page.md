---
title: Lucee 5.3 (Kabang) new features
menuTitle: Lucee 5.3 (Kabang) 
id: lucee_5.3_features
---

This document explains new features in Lucee Kabang (Lucee 5.3), every lucee version has a name from a dog that helped mankind. This version is named after a dog who helped rescue some children from a motorcycle accident.

For more information on Kabang, see [her story on wikipedia](https://en.wikipedia.org/wiki/Kabang)

### Main Focus ###

The main focus of Kabang is to improve the Lucee Administrator and debugging output.

### Administrator ###

In admin - > overview page now has four graphs which contain details about the heap memory and non-heap memory, CPU (Whole System, Lucee Process)

![Charts](/images/kabang/charts.PNG)

You can view the detailed information about Scopes in Memory, Request/CF Threads, Datasource Connections, Task Spooler

Scopes held in memory.  (Session/client scopes stored in external cache or datasource leave memory after 60 seconds of inactivity)

Requests/CF Threads- Request and CF Threads currently running on the system.

Datasource Connections-  Open datasource connections.

Task Spooler: Active and failed tasks in the Task Spooler.  This includes tasks to send E-mail messages.

![scopesImages](/images/kabang/scopesImages.PNG)

#### Extensions ####

Under Server Admin -> Applications, you can view the extensions: installed extensions and not installed extensions. Extensions that have not been installed are divided into three categories: Releases, Pre Release, Snapshots

You can enable them as you like or disable them.

![Extension Not Installed](/images/kabang/extNotInstalled.PNG)

Similarly, you can view the extensions installed. Go to the detail page of the extension and see the Releases, Pre-Release, and Snapshots for that extension. This allows us to handle different kinds of updates without changing the provider.

![Detail of the extension](/images/kabang/detailExtension.PNG)

#### Core Update ####

In services - > Update

You can view the Lucee core update provider. Here also we can see three kinds of providers: Releases, Pre Release, and Snapshots.

There is an overview of which versions are available without changing the provider.

![update provider](/images/kabang/updateProvider.PNG)

### Lucee Bundle Info ###

In Kabang you can see more details of the bundle versions. You can also sort the data by clicking on the title.

### Debug Output ###

In the Debug output we added two additional tabs: Metric and Reference

* Debug Tab -> Here you can view the debugging information detail

* Metrics tab - > This tab provides the same information you saw on the Admin overview page. There are four graphs which contain details about the heap memory and non-heap memory, CPU (Whole System, Lucee Process), and scope details what we see in overview page of the admin.

![Metric Tab](/images/kabang/MetricsTab.PNG)

* Reference - > In the reference tab we can reference the Lucee documentation.

![Reference Tab](/images/kabang/Referncetab.PNG)

In the debugging information, we also added additional information to tell you where an abort is happening within your Lucee code when you use cfabort tag.

You can add custom data to the debug using debugAdd() as shown in the example code below:

```lucee
<cfset debugAdd(
	"New in Lucee 5.3"
	,{
		'Debugging':"debugging provides more data than before"
		,'Admin':"admin has an improvement version handling"
	}
)>


<cfset debugAdd(
	"New in Lucee 5.3"
	,{
		'Code':"there is a lot to talk about"
	}
)>

```

You can see the above detail in debug tab by using debugAdd().

### Reduced Memory Foot Prints in Lucee ###

We done it three steps,

#### Move to extensions ####

We removed some core functionality to the extensions. These extensions are installed be default so you don't lose any extensions or functionality. However, if you do not need to use some functionality, you can uninstall the extension. These extensions include Axis, ESAPI, and Image. Also, since extensions are only loaded when used in Lucee, if you don't use the functionality, they will not get installed.

#### Removed XML parsers/transformers ####

Second thing is that we no longer the bundle external XML parsers and transformers with Lucee. In previous versions of Lucee, we always had external XML and transformers bundled, in addition to a couple of travel libraries that need lot of memory. In version 5.3 we use the libraries coming from JRE itself so they are already there. This also reduces the foot print

#### Java 8 minimal requirement ####

Third thing, we have raised the minimal Java requirement to Java 8 to run Kabang. This helps a lot with getting rid of legacy functionality and making the code smaller and more elegant.

### Improved Lucee Performance ###

Kabang reduces CPU usage for executing the same code. We did this with three steps.

### Better Byte code ####

Improved the Bytecode by addressing common patterns with specific bytecode

Example if the for loop

```luceescript
<cfscript>
	// typical usage
	for(i=0;i<10;i++) {
	}

	// more generic example
	i=0;
	for(;i<_max();_inc()) {
	}

	loop from=1 to=10 index="i" step=1 {
	}
</cfscript>
```
Byte code for the for statement is very complicated and not that fast. You can see the generic loop, but the byte code for the for statement is slower in previous versions because is more generic than what we did with Lucee 5.3. When the for is used in a certain way, we improve byte code and make it more specialized and faster. This is just one example of byte code optimization. 

#### Bytecode Optimized for Java >=8 ####

We raise the minimal requirement for Java. This allow as to create a byte code with more specialized code with Java 8. Lucee can create bytecode that no longer needs to be compatible with Java 7.

#### Unnecessary Buffering ####

BufferOutput is no longer used by default. Buffering the output slows the tag because it buffers everything until it reaches the end. It makes the code unnecessarily slow for a tag. By changing the default to not buffer the output, we free memory and CPU usage.

### Logging in Lucee ###

In Lucee Kabang, you can log to the datasource instead of only files. Go to admin - > Settings -> logging, edit the log file which you want to store into database.

![Logging](/images/kabang/logging.PNG)

You can select the datasource, create the name of the table and pass the custom data that will be provided with every log entry.

Now every thing will log into a datasource.

### Coding/Language ###

#### Mail Listener ####

The Mail Listener is triggered after mail is sent. After mail is sent, a closure function is called or can also be a component, so that you can tell from the code if mail was successfully sent or not.

```luceescript

// application.cfc
component {

	this.Name = "Lucee Mail";


	this.mail.listener=function() {
		systemOutput('--------------- function defined in Application.cfc ---------------',1,1);
		systemOutput(arguments.keyList(),1,1);
		systemOutput(detail,1,1);
	};
}
```

```lucee
<cfmail subject="Test Mail Listener" from="lucee.testing@mail.com" to="michael@lucee.org">
	This mail was sent to test the listener feature.
</cfmail>


<cfmail subject="Test Mail Listener" from="lucee.testing@mail.com" to="michael@lucee.org" listener="#function() {
	systemOutput('--------------- function defined with mail tag ---------------',true,true);
	systemOutput(arguments.keyList(),1,1);
	systemOutput(detail,1,1);
	}#">
	This mail was sent to test the listener feature.
</cfmail>

DONE!

```

Run the index.cfm we get the details of the mail in console. You can store the details of the mail listener in a datasource or wherever you like.

Don't forget to include `this.mail.listener=function()` in Application.cfc.

#### RSA Encryption ####

We know Lucee comes with different types of encryption so you can encrypt strings and binary with different encryption. RSA encryption is not simply a new kind of encryption. In RSA encryption we get two keys. One is a private key and the other is a public key. You encrypt with the private key and decrypt with the public key or vice versa (encrypt with public key and decrypt with private key). 

The idea behind this encryption is you can give out the public key and keep the private key for yourself.

Public/Private Key Encryption and Decryption

#### Example ####

```luceescript
	key=generateRSAKeys();
	dump(key);
	
	
	raw="Susi Sorglos föhnte Ihr Haar";
	enc=encrypt(raw,key.private,"rsa");
	dec=decrypt(enc,key.public,"rsa");
	dump(enc);
	dump(dec);
	enc=encrypt(raw,key.public,"rsa");
	dec=decrypt(enc,key.private,"rsa");
	dump(enc);
	dump(dec);
```

You cannot encrypt and decrypt with the same key. If we tried to encrypt and decrypt with the same key, Lucee will throw an error. It is a very handy way to handle encryption/decryption.

#### Extensions ####

Move the functionality to handle the extension. As you have seen, we have three new types of extension in Lucee 5.3. In the future we plan to have more and more extensions. So extensions are getting more and more important in Lucee. So we have made it easier to manage extensions.

The below example gets the extension provider details as a query:

```luceescript
	setting requesttimeout=1000;
	admin=new Administrator("web","server");
	
	// Providers
	dump(admin.getExtensionProviders())
```

The below example gets the list of extensions installed in the Web Context admin.getExtensions()) or in the Server Context (admin.getServerExtensions()), or all extensions (extensionList()) in Lucee:

```luceescript
dump(admin.getExtensions());
dump(admin.getServerExtensions());
dump(extensionList());
```

The below example describes how to install an extension using Administrator(). Pass the extension ID to the function updateExtension(extension), if not installed it will install the extension: (To find the ID of the extension ID, see the Lucee Admin -> extensions or on the Lucee download page.)
```luceescript
// Install Update MongoDB
admin=new Administrator("server","server");

admin.updateExtension("E6634E1A-4CC5-4839-A83C67549ECA8D5B");

dump(admin.getExtensions());

dump(extensionExists("E6634E1A-4CC5-4839-A83C67549ECA8D5B"));
```

The below example describes how to update an extension version:
```luceescript
admin=new Administrator("server","server");

admin.updateExtension("E6634E1A-4CC5-4839-A83C67549ECA8D5B","3.2.2.52");

dump(admin.getExtensions());

dump(extensionExists("E6634E1A-4CC5-4839-A83C67549ECA8D5B"));
```

The below example describes how to remove an extension installed from Lucee:
// Remove MongoDB
admin=new Administrator("server","server");
admin.removeExtension("E6634E1A-4CC5-4839-A83C67549ECA8D5B");
dump(admin.getExtensions());
dump(extensionExists("E6634E1A-4CC5-4839-A83C67549ECA8D5B"));

#### Cfquery ####

Added the attribute sql to the tag query. Instead of passing sql in the body of the tag, you can now pass it as a variable with the attribute sql.

Passing in the body of the tag (legacy code)
```lucee
<cfquery name="qry">
	select 1 as one
</cfquery>
<cfdump var="#qry#">


Passing as an attribute
<cfquery name="qry" sql="select 1 as one"/>
<cfdump var="#qry#">


Passing sql as an attribute within a script

<cfscript>
	query name="qry" sql="select 1 as one";
	dump(qry);
	sql="select 1 as one";
	cfquery(name="qry", sql=sql);
	dump(qry);
</cfscript>
```

#### FTP Resource ####

Lucee 5.3 adds the ability to define FTP credentials in Application.cfc/cfapplication for FTP resources. Use with prefix "ftp://". 

In previous versions of Lucee, the ftp credentials were seen in the code like this:
```luceescript
ftp = ftp://#request.ftp.user#:#request.ftp.pass#@ftp53.world4you.com:21/;

dump(directoryList(ftp));
```

This does not keep the credentials secure. In Lucee 5.3 FTP credentials can be supplied in the Application.cfc as shown in the example below: 
```luceescript
//application.cfc
component {
	this.ftp.username="myuser";
	this.ftp.password="myverysecretpw";
	this.ftp.host="ftp.lucee.org";
	this.ftp.port=21;
}

//index.cfm
ftp="ftp:///";

ftp="ftp://ftp53.world4you.com:21/";

ftp="ftp://ftp53.world4you.com/";

dump(directoryList(ftp));
```

Simply pass like this "ftp:///" it will list the directory,
You can pass host and port also, ftp="ftp://ftp53.world4you.com:21/"

### ACF 2018 Compatibility ###

ACF 2018 introduced a lot of new functionality. Luckily, Lucee already supports most of the new functionality. Supported features are listed below:

* Supported Closure Tag - > Lucee we already support closure functions inside tag and cfscript

* Abstract Component and Methods - > Lucee we already support Abstract components and its methods

* Final Component and Methods -> Already supported by Lucee

* Optional Semicolons - > In cfscript, Semicolon are optional and already supported by Lucee

* Support of Other Cache Engines (Memcache) -> always supported by Lucee

* Adding your own Cache Engine -> supported

* Full Null Support  - > You can enable or disable null support in admin

* Data Type Preservation (no setting to disable) -> always supported in Lucee

* Named Arguments with Build In Functions

* Member Function on string Literals

* Function ArrayFirst, ArrayLast, QueryDeleteColumn and QueryDeleteRow

#### Newly Supported in Lucee 5.3 ####

 * Null support can be defined in Application.cfc via (this.nullsupport=true), In Lucee we have enabled null support enable/disable from admin. Now we support with Application.cfc use like `this.nullsupport = true/false;` Or Use like what ACF2018 `this.EnableNullSupport = true/false;` 

 * Adding alias to match named argument names used by ACF. Use the same argument name as ACF2018 does

 * Member Functions for numbers

 * Types Array, Lucee also supports typed arrays like `arr=arrayNew(type:"boolean");` but ACF2018 uses a different syntax `arrayNew["string"](1);`

### BackWard Compatibility ###

There only two backward compatibility issues with Lucee Kabang: Buffer body and Java 8.

#### Buffer Body ####

Lucee, by default, no longer buffers the body in a `<cfsilent>`/ `<cffunction output="false"`>

#### Minimal Java 8 ####

Java 8 is the minimal requirement to run Lucee kabang (Lucee 5.3)

### Footnotes ###

Here you can see above details in video

[5.3 kabang video](https://youtu.be/A1f46rk0WrI)
