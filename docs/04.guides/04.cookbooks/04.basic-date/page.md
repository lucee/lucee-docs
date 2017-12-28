---
title: Basic Date
id: cookbook-basic-date
---

# Output the current date #

The following examples shows you how to output the current date.

```coldfusion
<html>
	<head>
		<title>Current date</title>
	</head>
	<body>
		<cfoutput>
		<p>The time is #lsdateTimeFormat(now())#</p>
		</cfoutput>
	</body>
</html>
```
Executing this code you will see something like the following:

> The time is 31-Jan-2038 11:12:08

The tag `<cfoutput>` defines for the compiler that everything within a `##` is a code expression and needs to be parsed accordingly. `now()` is a function call that is returning a date object containing the current time, `lsDateTimeFormat` then converts that date to a string using "locale" specific formatting rules (default en_US).

You can define a different locale globally in the Lucee admin at "Settings/Regional".
You can define a different locale for the current request in the Application.cfc file (for example: `this.locale="de_CH"`) or with help of the function `setLocale` or as argument of the function call itself as follows:

```coldfusion
<html>
	<head>
		<title>Current date</title>
	</head>
	<body>
		<cfoutput>
		<p>The time is #lsDateTimeFormat(date:now(),locale:'de_CH')#</p>
		</cfoutput>
	</body>
</html>
```
