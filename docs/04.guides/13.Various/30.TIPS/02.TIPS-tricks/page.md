---
title: Lucee Tips and Tricks
id: tips-and-tricks
---

## Tips and Tricks ##

If you have any tips that you would like to share, sent them to [contact@lucee.org](mailto:contact@lucee.org)

## Page pool ##

When you call a template in Lucee, the template lands in the page pool for reuse. The pages in the page pool are refreshed depending on the settings you have made in the Performance/Caching area of the Lucee administrator. Now if you want to make use of the setting "never" which will never look for changed templates during the lifetime of a server instance, you should use the built in function pagePoolClear() in order to flush the template cache (page pool).

If you want to see what pages are inside the page pool you can use the built in function pagePoolList(). The function returns an array with all the pages in the page pool

## Query cache ##

If you are using the query cache and you would like to flush the cache you can always use the tag in order to do so. The problem hereby is that this call flushes the complete cache which is a waste. In Lucee you can use some additional attributes like filter, filterignorecase and result.

The attributes filer and filterignorecase allow you to flush objects from the cache that match the filter. The filter gets applied like the sql statement like. So if you use the following tag:

```lucee
<cfobjectcache action="clear" filter="susi">
```

Then all elements in the query cache that are containing the string susi are flushed from the cache. This means you can easily remove all queries for a certain table if a table is updated on the database. The attribute filterignorecase does the same without obeying the case.

The next new attribute Lucee has introduced is result which can be used with the new action size. If you execute the following tag:

```lucee
<cfobjectcache action="size" result="cachesize">
```

the variable cachesize will contain the number of elements in the cache.

### Using gmail as a mail provider ###

```lucee
smtp.gmail.com (use authentication)
Use Authentication: Yes
Use STARTTLS: Yes (some clients call this SSL)
Port: 465 or 587
```

Additional resource: [http://jamiekrug.com/blog/index.cfm/2009/2/13/cfmail-using-Gmail-SMTP](http://jamiekrug.com/blog/index.cfm/2009/2/13/cfmail-using-Gmail-SMTP)

### Adding contexts in Resin 3.1.9 (without restart) ###

if you create a directory inside the Resin root called hosts and you create different directories in there named like the host name you expect, you just need to place a host.xml file in there that contains the following:

```lucee
<host xmlns="http://caucho.com/ns/resin">
    <host-alias>www.client.com</host-alias>
    <web-app id="/" root-directory="D:/sites/someclient"/>
</host>
```

And then the context is available at runtime without having to restart the engine. So if you add a new website to the server then you just need to complete the above steps and then you can access the site.

So my Resin directory looks like this:

```lucee
resin
    hosts
        Client1
            host.xml
        Client2
            host.xml
```

etc

### Hide the fact you are running Lucee from users ###

Sometimes you want to hide from users of your site, what underlying technology you are using. This takes a few steps:

1. Go to Lucee admin settings/error and replace error template with a custom error template that is plain or looks like an ASP or PHP error page, or of course, whatever template you want.
2. Add ```luceee<cfsetting showdebugoutput="no">``` at the top of this template.
3 . Go to Lucee admin settings/output and remove flag "Output Lucee version"
4. Go to WEB-INF/web.xml or etc/webdefault.xml or config/appdefault.xml depending on which servlet container you are running
5. Change all existing servlet-mappings from servlet "CFMLServlet" as follows
6. Replace cfm with asp and cfc with php or whatever you want. ```lucee

<servlet-mapping>
     <servlet-name>CFMLServlet</servlet-name>
     <url-pattern>*.asp</url-pattern>
 </servlet-mapping>
```
1. Go to existing application.cfc or create one, if there is more than one, do this for every application.cfc or extend a cfc in every application.cfc with the following function:

```lucee
<cffunction name="onRequest" output="yes">
	<cfargument name="path">
	<cfset var local.ext=mid(arguments.path,len(arguments.path)-2,3)>
	<!--- extension asp is used for cfm calls --->
	<cfif local.ext EQ "asp">
	<cfset var local.pathmod=mid(arguments.path,1,len(arguments.path)-3)&"cfm">
	<!--- extension php is used for cfc calls --->
	<cfelseif local.ext EQ "php">
	<cfset var local.pathmod=mid(arguments.path,1,len(arguments.path)-3)&"cfc">
	<cfelse>
	<cfset local.pathmod=arguments.path>
	</cfif>
	<cfsetting showdebugoutput="no">
	<cfinclude template="#local.pathmod#">
	<cfreturn true>
</cffunction>
```

**Restart Lucee**

## Getting the column list of a query object, case-sensitive! ##

It's really simple:

```lucee
<cfset caseSensitiveColumnList = queryObject.getColumnlist(false) />
```

Note: if you typed the actual column names in your SELECT statement, like in "SELECT userID, userName from users", then the exact column names you used there will be returned. But if you use "SELECT * from users", then the actual table column names are returned. See [http://www.luceedeveloper.com/post.cfm/lucee-tip-get-a-query-s-columnlist-case-sensitive this blog post] for more info.

### URL Rewriting ###

See Installation-URLRewriting

[[url-rewriting]]
