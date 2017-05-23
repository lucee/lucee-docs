---
title: First steps
id: getting-started-first-steps
---

# Your first Lucee Server template #

Most people start using "Lucee Express", so they will end up going to [http://localhost:8888](http://localhost:8888) after they've started Lucee Express, and if it's all gone well, you'll see the **"Welcome to the Lucee World!"** page.  If not, now's a good time to find out [[how to get help]].

The "Welcome to the Lucee World!" page is very helpful, because it tells us a lot of information about the Lucee CFML Server - the Lucee version, the Java version, and lots more besides - including the path where CFML files are served from.  You'll find the website's folder under "Important Notes".

If you've read the page about [[getting to know Lucee]], you'll know that Lucee uses CFML files, and we'll create our first CFML file (or template) now.

In your file explorer, find the website folder, create a file called `myFirstPage.cfm` and add the following to it:

```lucee
<html>
	<head>
		<title>My first page</title>
	</head>
	<body>
		<h1>Hello World!</h1>
		<cfoutput>
		<p>The time is #now()#</p>
		</cfoutput>
	</body>
</html>
```

Save the file, then head to http://localhost:8888/myFirstPage.cfm

You should see something like the following:

> **Hello World!**

> The time is {ts '2013-04-10 01:30:37'}.

If you did, congratulations!  You've written your first CFML template.  What's going on though?  Well, if you know HTML, the template will be mostly familiar.  Lucee Express has output the HTML as you wrote it.  Unless you tell it otherwise, Lucee Express will always output whatever's written in your template.  

The things you won't recognize are `<cfoutput>` and `#now()#` because these are instructions to the Lucee runtime compiler.  When it encounters these, it replaces them in the page with some dynamic output.  

`<cfoutput>` is a CFML tag.  It tells Lucee that it should look out for expressions.  Like HTML, it has a corresponding closing `</cfoutput>`.  

`#now()#` is a CFML function call.  When Lucee is inside a `<cfoutput>` block and sees a pair of `#` signs, it knows it should expect a expression - it will run the expression and put the results right into the page. As you've no doubt guessed, `#now()#` returns the current date and time.

Okay, this template isn't particularly useful... but it does show you how easy it to start working with Lucee.  You don't need to worry about builds, compilation or deployments if you don't want to.  You can just start writing CFML code.  

## Tag/Script
Lucee is in fact not one language, it is 2!
the tag language that you can see as extension to HTML and the script Language that you can see as extension to Javascript.
The example above was  pure tag code, tag code is perfect to create output, to mix with static HTML.

### Tag ###
The following fragment outputs some employee details from an employee object.  As you can see, the tag language slots right into your presentation format.  It's HTML in this case, but could just as easily be used to make RSS, XML, or indeed any data type you like.  

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
### Script ###
Of course a web application is not only about output information, it is also about doing business logic, convert data, ...
for this the language can be used, but it is not very handy, in that case it is better to use the script language.
When you are familiar with Javascript, this will be also very familiar to you.
Script code can be used in code island or with complete files, similar you can use Javascript within HTML.

This example gets a record from a database and populates an object.

```luceescript
var qry = new QueryExecute("select * from employee where id="&url.id);
var employee = new Employee();
employee.setName(qry.name);
employee.setDOB(qry.dob);
```

### Tag and Script ###

Of course you can use tag and script in the same file...

```lucee
<cfscript>
    var qry = new QueryExecute("select * from employee where id="&url.id);
    var employee = new Employee();
    employee.setName(qry.name);
    employee.setDOB(qry.dob);
</cfscript>

<cfoutput>
<h1>Employee details</h1>
<div>
    <dl>
        <dt>Name</dt>
        <dd>#employee.getName()#</dd>
        <dt>Date of birth</dt>
        <dd>#employee.getDOBasString()#</dd>
    </dl>
</div>
</cfoutput>
```
