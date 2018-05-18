---
title: Externalize strings
id: Externalizing_Strings
---
## Externalize strings ##

Externalize strings from generated class files to separate files. This method is used to reduce the memory of the static contents for templates. We explain this method with a simple example below:

**Example:**

```lucee
//index.cfm page 

<cfset year = 1960>
<html>
	<body>
		<h1>....</h1>
		.......
		.......
		It was popular in the <cfoutput> #year# </cfoutput>
		.......
		<b>....</b>
	</body>
</html>
```

1. Here Index.cfm file contains lot of strings(static contents) inside, but there is no functionality. Just give a cfoutput with year, In year is already declared by using <cfset> in top of the Index.cfm page.  

2. Execute that cfm page in browser. A class file is created in ``webapps\ROOT\WEB-INF\lucee\cfclasses\`` directrory while execute a cfm file. The run time compiler compiles that file to load the java bytecode and execute it. 

3. Right click that class file, then see ``Get info``. For example, In my class file have 8Kb size on disk. In lucee loaded that cfm file with their strings also, So that could be a lot of memory occupied just by string loaded bytecode. Then avoiding this problem, lucee admin have one solution of this. 
   - Lucee admin --> Language/compiler --> Externalize strings
   - This ``Externalize strings`` Setting have four options. Select any one option for test. we selected fourth one (externalize strings larger than 10 characters).
   - Again run that cfm page in browser. The class file is created with lower memory size(8Kb on disk). 
   - In additionally it was created one text file too. The txt file is the string of the CFM page, Then cfoutput with year is simply not there. The byte code will be crop the piece of cfoutput content from the Cfm file.

So, This is no longer in memory when the bytecode is called it loads that into memory. The memory is not occupied forever and reduce the footprint of our application.

### Footnotes ###

Here you can see above details in video

[Lucee Precompiled Code ](https://youtu.be/AUcsHkVFXHE)