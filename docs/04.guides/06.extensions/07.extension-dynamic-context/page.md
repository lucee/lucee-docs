---
title: Dynamic Extension Content
id: extension-dynamic-content
---

### Dynamic content in the config.xml ###

**Dynamic**

When you use the attribute dynamic, you can define a method that is called in order to fill the value of this element. The value must be a valid method name of the component install.cfc.

```lucee
<source lang="xml">
...
<item dynamic="fillRoot" label="Root" name="root" type="text"/>
...
</source>
The corresponding method in the install.cfc might look like this:
install.cfc:
<source lang="xml">
<cfcomponent>
<cffunction name="fillRoot" returntype="void" output="no">
<cfargument name="item" required="yes">
<cfset item.setValue(now())>
</cffunction>
</cfcomponent>
</source>
For all the tags in the XML there is an equivalent CFC component that can be filled with data. The CFC hierarchy is described further below.
Inside the methed you can create item options as well:
install.cfc:
<source lang="coldfusion">
<cfcomponent>
<cffunction name="fillOther" returntype="void" output="no">
<cfargument name="item" required="yes">
<cfset item.createOption(value:"first",label:"First",selected:true)>
<cfset item.createOption(value:"second",label:"Second")>
</cffunction>
</cfcomponent>
</source>
The attribute dynamic can be used in all tags defined in the xml, including the root tag config (except of course the option tag).
<source lang="xml">
...
<group dynamic="fillGroup" label="dynamic Group">
...
</source>
install.cfc:
<source lang="coldfusion">
<cfcomponent>
	<cffunction name="fillGroup" returntype="void" output="no">
		<cfargument name="group" required="yes">
		<cfset item=group.createItem(type:'radio',name:'happy',label:'Happy?')>
		<cfset item.createOption(value:true,label:'Yes',selected:true)>
		<cfset item.createOption(value:false,label:'No')>
		<cfset item=group.createItem(type:'text',name:'fullname',label:'Fullname', description:'What is your Fullname?')>
	</cffunction>
</cfcomponent>
</source>
```

Next step - [[extension-cfcs-matrix]]
