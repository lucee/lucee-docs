---
title: Defining a datasource
id: cookbook-datasource-define-datasource
---

# How to define a Datasource #
To execute queries you need a datasource definition, a datasource definition point this a specific local or remote datasource, there are different ways to do so.

## Create a Datasource in the Administrator ##
The most common way is to define a Datasource is in the Lucee Server or Web Administrator.
The only difference between the Web and Server Administrator is, that datasources defined in the Server Administrator are visible to all web contexts and datasources defined in the Web Administrator only to the current web context.
In your Administrator go to the Page "Services/Datasource", in the section "create new Datasource" choose a name for your datasource and the type of your Datasource, for example "MySQL".

![create datasource](https://bitbucket.org/repo/rX87Rq/images/3802808059-createds.png)

On the following page you can define settings to connect to your datasource, the look and feel of this page depends on the datasource type used.
After saving this page you get back to the overview page and you will get a feedback if Lucee was able to connect to your datasource or not.

## Create a Datasource in the Application.cfc ##
You cannot only define a datasource in the Lucee Administrator, you can also do this in the [[cookbook-application-context-basic]], the easiest way to do so, is to create first a datasource in the Administrator (see above) and then go to the detail view of this datasource by clicking the "edit button"

![select datasource](https://bitbucket.org/repo/rX87Rq/images/4142224660-select-datasource.png)

At the bottom of the detail page you find a box that will look like this

![datasource application definition](https://bitbucket.org/repo/rX87Rq/images/1656402808-datasource-app-def.png)

You can simply copy the code inside the box to your [[cookbook-application-context-basic]] body, Lucee will pick then this definition.
After that you can delete the datasource you have defined in the Administrator.

### Advanced ###
Like you can see, the code for a datasource definition has this pattern (class,  connectionString, username and password)

```cfs

this.datasources["myds"] = {
	  class: 'org.gjt.mm.mysql.Driver'
	, connectionString: 'jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
	, username: 'root'
	, password: "encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854"
};

```
but alternatively you can also use this pattern

```cfs

this.datasources["myds"] = {
         // required
        type: 'mysql'
        , host: 'localhost'
        , database: 'test'
        , port: 3306
        , username: 'root'
        , password: "encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854"

        // optional
        , connectionLimit: -1 // how many connections are allowed maximal (-1 == infiniti)
        , connectionTimeout:1 // connection timeout in minutes (0 == connection is released after usage)
        , blob: false // enable blob
        , clob: false // enable clob
        , storage: false // allow to use this datasource as a session/application storage
        , timezone: 'CET'  // if set Lucee change the environment timezone
        , custom: {useUnicode:true,characterEncoding:'UTF-8'} // a struct that contains type specific settings
};

```

### Default Datasource ###
With the [[cookbook-application-context-basic]] you can also define a default datasource that is used if not "datasource" attribute is defined with the tag cfquery, cfstoredproc, cfinsert, cfupdate, ..., simply do the following

```cfs

this.defaultdatasource = "myds"; // "this.datasource" is supported as well
```

In that case the datasource "myds" is used, if there is no datasource defined. Instead of defining a datasource name, you can also define the datasource directly as follows

```cfs

this.datasource = {
	  class: 'org.gjt.mm.mysql.Driver'
	, connectionString: 'jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
	, username: 'root'
	, password: "encrypted:5120611ea34c6123fd85120a0c27ab23fd81ea34cb854"
};

```
