---
title: Custom Date and Time format for a Locale using .df files
id: custom dateTime format locale files
related:
- function-lsparsedatetime
categories:
- datetime
- locale
description: This documentation shows how to set the custom date and time format using .df files
---

### Why the locale files (.df) needed ###
Some locales not support some of the date time formats which was usually supported by other locales.
For example, <code>English (Australian)</code> doesn't support the date format with hyphen <code>(i.e 01-01-2000 00:00:00)</code>. So the <strong>.df</strong> files provides the options to support custom date and time formats.

### How/Where to add the locale file ###
Create the following files [*Locale_ID-datetime.df* (for date time formats), *Locale_ID-date.df* (for date formats) or *Locale_ID-time.df* (for time formats)] with the format you want to supports in the following directory [<code>&lt;web-context&gt;/lucee/locales/</code>] and restart lucee.

Example for <code>English (Australian)</code> create a file <strong>en-AU-datetime.df</strong> in <code>WEB-INF/lucee/locales/</code> with below content 

```lucee
MM-dd-yyyy HH:mm:ss
```

And restart lucee/tomcat.

So now the <code>lsParseDateTime()</code> with locale en_AU <code>(English (Australian))</code> supports date time string like <code>01-01-2000 00:00:00</code>.

If you want to add more formats to be supported. Append the format you want to support in a new line on that file like
```
MM-dd-yyyy HH:mm:ss

yyyy/MM/dd HH:mm:ss

yyyy-MM-dd HH:mm:ss

yyyy-MM-dd

yyyy/MM/dd
```
So now these formats are supported by the <code>lsParseDateTime()</code> with locale en_AU <code>(English (Australian))</code>.

>>> ***Note:*** the locale file needs the java masks (ex: mm for Minute) for that from here <a href="https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html">SimpleDateFormat (Java Platform SE 7 )</a>.
