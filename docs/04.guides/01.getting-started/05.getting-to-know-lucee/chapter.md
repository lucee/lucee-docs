---
title: Getting to know Lucee Server
id:  getting-to-know-lucee
---

## What do you get with Lucee Server? ##


Lucee Server is a CFML engine. It allows you to write powerful web-based systems and deploy them to a variety of platforms.

Lucee Server is written in Java and runs in a Java Servlet Container. When you download and install Lucee Server, you get a Servlet Container plus the Lucee code.

But you don't need to worry about that: you access Lucee Server features using CFML, a fast, easy-to-use language that you'll learn in no time at all.

Just write CFML files - typically one per page on your site - and then request them through the browser. Lucee Server will compile your work the first time you request that page.

Lucee Server comes bundled with a lot of services that you'll find useful in building your apps - session management, database connectivity, ORM, search engine, mail, scheduling, fast caches, subsystems for accessing disks, remote servers, Amazon services, support for REST, XML, JSON and much more. At the core of Lucee Server is the Lucee Server Administrator - a web application that lets you configure and maintain your own Lucee applications.


## About CFML ##

CFML, or ColdFusion Markup Language is a catch-all term for a tag-based markup language (CFML) and its scripting counterpart (CFScript). It's an easy-to-learn language that abstracts away unnecessary complexity, leaving you to focus on building functionality.

Typically, you use CFML to write output templates, and CFScript to write business logic, though that's not set in stone -- you can mix and match as you wish.

Here's an example of both:

## CFML ##

CFML code usually goes into files with a .cfm extension.

This fragment outputs some employee details from an employee object, or bean. As you can see, CFML slots right into your presentation format. It's HTML in this case, but could just as easily be used to make RSS, XML, or indeed any data type you like.

```lucee
<cfoutput>
    <h1>Employee details</h1>
    <div>
        <dl>
            <dt>Name</dt>
            <dd>#employee.getName()#</dd>
            <dt>Date of birth</dt>
            <dd>#DateFormat(employee.getDOB(), "dd/mm/yyyy")#</dd>
        </dl>
    </div>
</cfoutput>
```

## CFScript ##

CFScript code usually goes into files with a .cfc extension.

This fragment gets a record from a database and populates an object or bean.

```luceescript
var employeeQuery = new Query();
employeeQuery.setSQL("select name, dob from employee where id = :id");
employeeQuery.addParam(name="id", cfsqltype="cf_sql_integer", value="#url.id#");
employeeQuery.execute();
var getEmployee = employeeQuery.getResult();
var employee = new Employee();
employee.setName(getEmployee.name);
employee.setDOB(getEmployee.dob);
```

## Mixed mode ##

It's good practice to keep business logic and presentation separate, but if you want to prototype something quickly, you can bundle them together...
```lucee
<cfquery name="getEmployee">
    select name, dob from employee
    where id = <cfqueryparam type="cf_sql_integer" value="#url.id#">
</cfquery>
```

```lucee
<cfoutput query="getEmployee">
    <h1>Employee details</h1>
    <div>
        <dl>
            <dt>Name</dt>
            <dd>#name#</dd>
            <dt>Date of birth</dt>
            <dd>#DateFormat(dob, "dd/mm/yyyy")#</dd>
        </dl>
    </div>
</cfoutput>
```

... or mix and match CFML & CFScript like this:

```cfs
<cfscript>
    var getEmployeeQuery = new Query();
    getEmployeeQuery.setSQL("select name, dob from employee where id = :id");
    getEmployeeQuery.addParam(name="id", cfsqltype="cf_sql_integer", value="#url.id#");
    getEmployeeQuery.execute();
    var getEmployee = getEmployeeQuery.getResult();
</cfscript>
```
```lucee
<cfoutput query="getEmployee">
    <h1>Employee details</h1>
    <div>
        <dl>
            <dt>Name</dt>
            <dd>#name#</dd>
            <dt>Date of birth</dt>
            <dd>#DateFormat(dob, "dd/mm/yyyy")#</dd>
        </dl>
    </div>
</cfoutput>
```

## How CFML developed ##

CFML was invented by the Allaire brothers, back in 1995. Web pioneers, they had a vision of a language and platform that would allow easy connections between web pages and databases, freeing developers from the complexities of web development.

They came up with a tag-based syntax with would be familiar to those with HTML experience, and produced ColdFusion, their CFML server.

Before long, ColdFusion had been ported so that it worked on Windows & Unix platforms, and by 1999 had gained the ability to work with Java objects.

Perhaps ColdFusion's biggest changed happened in 2002, when it was released rewritten in Java and with support for object-oriented programming in CFML.

Since then, CFML has been enhanced over successive versions, helped by the introduction of the former CFML Advisory Committee, and the development of products like Lucee Server.

## Lucee Server & CFML compared with... ##

[[lucee-server-compared-with-dotnet]]

[[lucee-server-compared-with-java]]


## Quick history of Lucee Server ##

###How Lucee Server came to be ###

Lucee started life in 2002 as a student project, which had to compile CFML code into something else. The original choice was that it should convert from CFML to PHP, but the result proved not to be stable or fast enough.

The decision was taken to move to Java, and before long it was clear that the performance was so much better than other CFML engines! So, it was decided to continue the project and produce a brand new server product.


### The Lucee Company ###

For many companies, open-source projects aren't suitable perhaps because of lack of support, training or consulting services available. Lucee Technologies, the company originally behind the development of Lucee Server, decided to offer these commercial services to make sure that companies could rely on Lucee Server.

In 2012, at cf.Objective(), the largest conference dedicated to the CFML community, it was announced that a new company, The Lucee Company Ltd was to be launched. Lucee's CEO & CIO both said that the venture would focus on delivering the Lucee Server platform for the foreseeable future.

The Lucee Company was formed by investors from leading CFML users in the US and Europe. Together, the investors will ensure that Lucee Server is expanded, with an emphases on training, documentation, new licensing options, support and consultancy.

Read more about this in the [press announcement](http://www.getrailo.com/index.cfm/about-us/news/railo-announces-launch-of-investor-backed-global-venture/) by Lucee's CEO, Gert Franz.