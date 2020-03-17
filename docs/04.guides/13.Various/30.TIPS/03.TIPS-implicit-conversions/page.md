---
title: Implicit Conversions
id: tips-implicit-conversions
---

Following up with [[tips-magic-functions]], there's one more gem. Again, this has been around since Lucee 2. We're going to make a new, yet similar example. This time, we're going to create an address object:

address.cfc

```lucee
<cfcomponent output="false">
<cffunction name="init" access="public" returntype="address" output="false">
	<cfreturn this>
</cffunction>
<cffunction name="setStreet1" access="public" returntype="void" output="false">
	<cfargument name="street" required="true" type="string" default="">
	<cfif len(arguments.street)>
		<cfset variables.street1 = arguments.street>
	<cfelse>
		<cfthrow message="Street 1 is required.">
	</cfif>
</cffunction>
<cffunction name="setCity" access="public" returntype="void" output="false">
	<cfargument name="city" required="true" type="string" default="">
		<cfif len(arguments.city)>
			<cfset variables.city = arguments.city>
		<cfelse>
			<cfthrow message="City is required.">
		</cfif>
</cffunction>
<cffunction name="setState" access="public" returntype="void" output="false">
	<cfargument name="state" required="true" type="string" default="">
	<cfif len(arguments.state) EQ 2>
		<cfset variables.state = arguments.state>
	<cfelse>
		<cfthrow message="State is required and must be a 2 character length.">
	</cfif>
</cffunction>
<cffunction name="setPostalCode" access="public" returntype="void" output="false">
	<cfargument name="postalcode" required="true" type="string" default="">
	<cfif len(arguments.postalcode)>
		<cfset variables.postalcode = arguments.postalcode>
	<cfelse>
		<cfthrow message="Postal Code is required.">
	</cfif>
</cffunction>
<cffunction name="getStreet1" access="public" returntype="string" output="false">
	<cfreturn variables.street1>
</cffunction>
<cffunction name="getCity" access="public" returntype="string" output="false">
	<cfreturn variables.city>
</cffunction>
<cffunction name="getState" access="public" returntype="string" output="false">
	<cfreturn variables.state>
</cffunction>
<cffunction name="getPostalCode" access="public" returntype="string" output="false">
	<cfreturn variables.postalcode>
</cffunction>
<cffunction name="_toString" access="public" returntype="string" output="false">
	<cfset var address = "">
	<cfsavecontent variable="address"><cfoutput>#getStreet1()#<br>#getCity()#, #getState()# #getPostalCode()#</cfoutput></cfsavecontent>
	<cfreturn address>
</cffunction>
</cfcomponent>
```

*index.cfm*

```lucee
<cfset address = createObject('component','address').init()>
<cfset address.street1 = "Some Street">
<cfset address.city = "Some City">
<cfset address.state = "CA">
<cfset address.postalcode = "12345">
<cfoutput>#address#</cfoutput>
```

Now, in the address.cfc, note that we have a new function named "_toString" - This is a special conversion/function method name. There are other simple types available:

* _toBoolean()
* _toDate
* _toNumeric
* _toString

Now, let's look at the output of my address object:

	Some Street
	Some City, CA 12345

As you can see, the address object was converted to a string via the _toString function.
