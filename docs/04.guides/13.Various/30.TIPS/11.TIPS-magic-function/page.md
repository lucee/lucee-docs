---
title: 'Magic Functions - Implicit Component Getters / Setters '
id: tips-magic-functions
categories:
- component
---

### Enabling Magic Functions via Admin ###

You can enable magic functions in the web / server context by going to:

	http://{your host name}/lucee/admin/web.cfm?action=resources.component - Local web context
	http://{your host name}/lucee/admin/server.cfm?action=resources.component - Global web context

Enable the setting: `Implicit notation`

**The Code**

Once, you've checked and enabled it, we're ready to start with some code.

Created `person.cfc` with the following code:

*person.cfc*

```lucee
<cfcomponent>
<cffunction name="init" access="public" output="no" hint="initialization">
	<cfreturn this>
</cffunction>
<cffunction name="setAge" access="public" output="no" hint="This sets the age">
	<cfargument name="value" required="yes" type="numeric">
	<cfif arguments.value LT 30>
		<cfthrow message="Blah! You're just a young pup!">
	<cfelse>
		<cfset variables.age = arguments.value>
	</cfif>
</cffunction>
<cffunction name="getAge" access="public" returntype="string" output="no" hint="This gets the age">
	<cfreturn "My age is #variables.age#">
</cffunction>
<cffunction name="dump" access="public" output="no" hint="I'm just here for debugging purposes">
	<cfreturn variables>
</cffunction>
</cfcomponent>
```

So, this is a person object, but I didn't declare `age` or `name` anywhere. I did create two age specific functions ( `getAge()` / `setAge()` ). Now, I'm going to call my Person component via an `index.cfm`:

```lucee
<cfset oPerson = createObject('component','person').init()>

<cfdump var="#oPerson#">
```

### My dump: ###

Now, let's play around a little bit by setting some properties and cfoutput'ing it:

```lucee
<cfset oPerson.name = "Todd Rafferty">
<cfset oPerson.age = 37>
<cfoutput>#oPerson.name#</cfoutput>
<cfoutput>#oPerson.age#</cfoutput>
```

**Result**

So, you can see here that `oPerson.age` didn't output to just "37", it actually returned "My age is 37" as found in the `getAge()` function. Now, what happens if I try to lie and I say that I'm 29?

	`<cfset oPerson.age = 29>`

The result?

You could further expand on this so that `setName()` validates that the user actually exists and throws an error if it doesn't.
