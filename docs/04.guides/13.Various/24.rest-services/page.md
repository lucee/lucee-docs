---
title: 'REST Services: Introduction'
id: rest-services-introduction
related:
- function-restdeleteapplication
- function-restinitapplication
- function-restsetresponse
categories:
- ajax
menuTitle: REST Services
---

## Lucee and REST Services ##

This documentation shows how to setup and configure Lucee Server to serve REST (Representation State Transfer).
<br>
<br>

### 1. Introduction ###

REST is an application architecture which defines stateless data transfer over networked services. In the context of the web REST is commonly implemented over HTTP as it is a RESTful protocol. 

Lucee Server gives you the ability to define REST Services in as a collection of CFC components by using a set of REST specific attributes; and then configuring Lucee about which REST path should be used to access the service. 

Following you will learn how to setup REST in Lucee by adding a small example REST application with a REST service mapped to the name **metrics** ( which will be served by accessing the URL `http://localhost:8888/rest/metrics/` ).
<br>
<br>

### 2. Setting up REST services with Lucee ###

REST requests are executed by an additional servlet (RestServlet) that is shipped with Lucee and already pre-configured and enabled in Tomcat by default. 

Thus, you won't need to do any additional configurations in Tomcat. All you need is to setup a REST service to your Application.

In Lucee you have two main options to add a REST service to your Application: 
<br>
<br>

#### Option 1: Setting up REST service in Lucee's Server Administrator or Web Administrator ####

* **Step 1:** Log into your Lucee Server Administrator or Web Administrator and navigate to **Archives & Resources** &raquo; **Rest**.

* **Step 2:** Add a new mapping in the *Create new mapping* section with following values: 
    * **Virtual:** *metrics*
    * **Physical:** *C:\path-to-location-with-your-rest-components\\* and click on **save**

* **Step 3:** OPTIONAL: To make sure the REST services are correctly set up, activate the check box for **List services**. When enabled, you'll see a list of all the REST service mappings by navigating to `http://localhost:8888/rest/` (this will list all REST mappings created for the localhost web-context). 
<br>
<br>

#### Option 2: Setting up REST service by defining a REST mapping in Application.cfc ####

A simple way to setup REST is by defining the service in your `Application.cfc` with the [[function-restinitapplication]] function like so:

```
component  {
    
    // Application.cfc component
    
    // set a name for the REST application:
    this.name = "myRestApplication";
	
    
    // Define a REST service for the path 'metrics' pointing to the REST application located at 
    // "C:\path-to-location-with-your-rest-components\" (accessible through http://localhost:8888/rest/metrics/) 
    restInitApplication( 
            dirPath="C:\path-to-location-with-your-rest-components\", 
            serviceMapping="metrics", 
            password="YourLuceeWebAdministratorPassword"
    );
	
	
}
```

**Important**: You have to navigate to a .cfm template with your browser first to invoke the Application.cfc above. Not doing this will result in a missing REST mapping. If necessary, create an empty index.cfm file und open it in the browser to invoke the `Application.cfc`.
<br>
<br>

### 3. Verifying/listing available mapped REST services ###

If you have enabled **List services** in the REST settings of your Lucee Server Administrator or Web Administrator as shown in Step 3 of Option 1, then you'll be able to list all the available REST mappings by calling `http://localhost:8888/rest/`. 

**Common pitfalls:** If you are not seeing your registered REST mappings in the listings, then try the following:

* If you've added the REST mapping in Lucee's Web Administrator, make sure you are accessing REST in the very same web context. Example: Adding a REST service in the Web Administrator of `http://localhost:8888/lucee/admin/web` will be available only at `http://localhost:8888/rest/` but not at `http://www.my-own-domain.com:8888/rest/`.

* Verify if you're using the correct Lucee Administrator's password in the password-attribute of the [[function-restinitapplication]] function.

* Plain REST requests won't invoke the Applicaton.cfc, thus no REST mapping will be added with the [[function-restinitapplication]] function with pure REST requests. Try running a `.cfm` template to invoke the `Application.cfc` then. If your application doesn't have a .cfm template, create an empty index.cfm and run it. This will ensure that the [[function-restinitapplication]] function in `Application.cfc` gets executed. It's also possible to create a special template (e.g. `initRest.cfm`) containing the [[function-restinitapplication]] function for the simple purpose of executing that function as an update of the REST mapping.
<br>
<br>

### 4. Creating the REST example application ###

After having defined the REST service with the virtual path 'metrics' mapped to the full path "C:\path-to-location-with-your-rest-components\", we can now create a CFC-Component named *System.cfc* in that directory with the following code:

```
component restpath="/system"  rest="true" {

    // System.cfc

    /**
    * @hint returns server operating system by accessing the path /rest/mappedRESTServiceName/system/os
    */
    remote struct function getOS() httpmethod="GET" restpath="os" {
        return server.os;
    }

    /**
    * @hint returns specific timezone struct values by passing the timezones struct key name
    *  with the path /rest/mappedRESTServiceName/system/timezone/{timezone-struct-keyName}
    *  e.g. /rest/mappedRESTServiceName/system/timezone/name 
    *  or   /rest/mappedRESTServiceName/system/timezone/id
    */
    remote string function getTimeZone(
                required string key restargsource="Path",
                string locale="en_US" restargsource="url")
                httpmethod="GET" restpath="timezone/{key}" {

        setLocale(arguments.locale);
        var tzInfo=getTimeZoneInfo();

        return tzInfo[arguments.key];
    }
}
```

After that you'll be able to retrieve the REST URLs like the following:

```
http://localhost:8888/rest/metrics/system/os
http://localhost:8888/rest/metrics/system/timezone/name
http://localhost:8888/rest/metrics/system/timezone/id
http://localhost:8888/rest/metrics/system/timezone/name?locale=pt_BR
http://localhost:8888/rest/metrics/system/timezone/name?locale=zh_TW
http://localhost:8888/rest/metrics/system/timezone/utcHourOffset
```

<br>

### 5. Configuring your fronted web server to serve Lucee's REST services (Internet Information Services (IIS) and Apache2 ) ###

In the preceding steps we have added a REST service mapping named "metrics" serving REST resources with a CFC component
named `System.cfc` to Lucee. While the resources are accessible on Lucees default port 8888 you might not be able to access the services with a frontend webserver through port 80 or 443. This is because IIS, Apache2 or whatever server you are using in front of Lucee may need additional configuration to pass the REST requests `rest/*` to Tomcat/Lucee. 

To intercept requests for `rest/*` paths and direct them to Tomcat/Lucee, follow the instructions below:
<br>
<br>

#### For Internet Information Services (IIS) on Windows: ####

* *Step 1:* Open the "Internet Internet Information Services (IIS) Manager"

* *Step 2:* Select the main server node for global settings, or the specific site you'd like to add the REST service 

* *Step 3:* Open "Handler Mappings" with a double click

* *Step 4:* Open an existing valid Boncode connector mapping (e.g. for *.cfm). We will use it to copy the type value string.

* *Step 5:* Select the complete value of the "Type" attribute and copy it to clipboard. The string looks similar to *BonCodeIIS.BonCodeCallHandler,BonCodeIIS,Version=1.0.0.0,Culture=neutral,PublicKeyToken=...*. Close the detailed view without applying any changes by clicking *Cancel*.

* *Step 6:* In the right top corner click on "add managed hander" and add the following values:
    * *Request path:* rest/*
    * *Type:* {paste here the copied Boncode value string from Step 5}
    * *Name:* Boncode-Tomcat-REST

* *Step 7:* Click on **Request Restrictions** and uncheck *invoke handler only if request is mapped to:*

* *Step 8:* Apply the changes by clicking **Ok**
<br>
<br>

#### For Apache2 on Ubuntu/Linux ####

* *Step 1:* Find the settings for the "ProxyPassMatch" directive configuration for `*.cfc` and `*.cfm` files of your Apache2: In a Lucee default installation you'll usually find the directives at */etc/apache2/apache2.conf* or */etc/httpd/conf/httpd.conf*.  

* *Step 2:* Find the following commented line:

```
# ProxyPassMatch ^/rest/(.*)$ http://127.0.0.1:8009/rest/$1
```

and uncomment it by removing the preceding hash sign `#` like so:

```
ProxyPassMatch ^/rest/(.*)$ http://127.0.0.1:8009/rest/$1
```

If you are using AJP instead of reverse http proxy, the line should be adapted accorgingly 
by changing the string *http://* to *ajp://*, that would be: `ProxyPassMatch ^/rest/(.*)$ ajp://127.0.0.1:8009/rest/$1`.

* *Step 3:* Restart/reload apache2 configuration with the command

```
$ sudo systemctl restart apache2
```

<br>
<br>

### 6. Important information when running REST applications behind IIS or Apache2 with mod_cfml enabled ###

**Issue with mod_cfml:** By time of this writing **mod_cfml** is not supporting automatic configuration for pure REST web applications. 

The reason is that even if you have IIS or Apache2 configured properly, mod_cfml will fail to identify the requests (with path `rest/*`) as being cfml requests, unless they contain` .cfc` or `.cfml` in the url.

As a result, mod_cfml will fail to recognise these requests and won't create the Tomcat web contexts for new added site/hostname in IIS/Apache (mod_cfml task is to create the context settings for sites/virtual hosts added to IIS/Apache in Tomcats configuration automatically for you). 

Because Tomcat has no configuration set up for those new added sites, Tomcat will deliver it's default webroot, causing the impression that Lucee serves only REST applications from Tomcats default server root at Tomcat/webapps/ROOT.

**The quick fix**: The quickest solution is to add an empty `index.cfm` template at the physical location of the webroot of IIS site or apache virtual host and call the `index.cfm` file through port 80 (or 443 for https) of your IIS or Apache2. 

Then wait for *mod_cfml* to create the context in Tomcat. After that the REST service should be accesible through port 80 of IIS or Apache without issues. 

Once the *mod_cfml* has successfully created the host configuration in Tomcat, you can safely remove the empty `index.cfm` file.
<br>
<br>

### 7. Reference & Usage ###

Find below a quick reference overview of specific component attributes and functions related to REST and CFML. Please watch also this [video about Lucee REST Server](https://www.youtube.com/watch?v=R_VnRawOhhc) that shows how to create REST components in Lucee.
<br>
<br>

#### 7.1 CFcomponent attributes for REST #### 
	
* **rest (boolean):** enables/disables the component as an accessible rest component. Default value is `true`. Set it to false if you wish to disable to component to serve REST services.
* **restpath (string):** defines the path that invokes the component. Use this to define your own REST path in case you don't want to use the components name.
* **httpMethod (string):** defines the http method to access the component. All values that are supported and allowed by the server can be used. Common values are `GET | POST | PUT | UPDATE | DELETE | HEAD | OPTIONS`
<br>
<br>

#### 7.2 CFfunction attributes for REST #### 

* **access='remote':** makes the function remotely accessible
* **restpath (string):** defines the path that invokes the function
* **httpMethod (string)** defines the http method to access the function. All values that are supported and allowed by the server can be used. Common values are `GET | POST | PUT | UPDATE | DELETE | HEAD | OPTIONS`
* **produces (string):** defines the content-type of the server response, e.g. `text/plain | text/html | application/json | application/xml` or other valid mime-types. Default is `application/json`.
* **consumes (sting):** defines the content-type of the expected request body from the client.
<br>
<br>

#### 7.3 CFargument ####

* **restArgName (string):**  Defines the variable name of the request data.  
* **restArgSource (string):** Defines the data scope for the variable name to be extracted. Possible values are `PATH | QUERY | FORM | MATRI | HEADER | COOKIE`
<br>
<br>

### 8. Using file extensions to format return data ###

Lucee sends REST data with a return format of JSON by default. To offer better data interoperability Lucee supports different return formats by specifying specific file extensions. Possible file extensions to define data return formats are `json | xml | wddx | json | java | serialize`.

```


// returns data as JSON
http://localhost:8888/rest/metrics/system/os


// also returns data as JSON
http://localhost:8888/rest/metrics/system/os.json


// returns data as XML
http://localhost:8888/rest/metrics/system/os.xml


// returns data as WDDX
http://localhost:8888/rest/metrics/system/os.wddx


// returns data as a java binary object, which can be loaded via ObjectLoad(obj)
http://localhost:8888/rest/metrics/system/os.java


// returns data the same way as doing serialize(obj)
http://localhost:8888/rest/metrics/system/os.serialize


```

<br>
<br>

### 9. Introduction video about REST and Lucee ###

For a more comprehensive explanation please watch the following video:
<div>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=R_VnRawOhhc
" target="_blank"><img src="http://img.youtube.com/vi/R_VnRawOhhc/0.jpg"
alt="RESTful Server" width="320" border="10" /></a></div>
<br>
<br>
<br>
<br>

* Building a REST Service
* Design & Architecture
* Writing a REST Component
* Writing a REST Function
