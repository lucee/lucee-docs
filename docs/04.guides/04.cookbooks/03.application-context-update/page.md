---
title: Update current Application Context
id: cookbook-application-context-update
related:
- tag-application
menuTitle: Application Context
---

# Update Application Context #
Lucee allows to update a existing application context defined for example with a Application.cfc.
So for example add a per application mapping

```lucee
<!--- creates a mapping with name "/test" that is pointing to the current directory --->
<cfapplication action="update" mappings="#{'/test':getDirectoryFromPath(getCurrentTemplatePath())}#">
```

this examples does not extend the already defined per application mappings with this new one, it replaces them. So when you plan to add a mapping best read the existing mappings with help of the function getApplicationSettings() and extend this mappings as follows:

```lucee
<!--- read the existing per application mappings --->
<cfset mappings=getApplicationSettings().mappings>

<!--- add a mapping with name "/test" to the mappings struct --->
<cfset mappings['/test']=getDirectoryFromPath(getCurrentTemplatePath())>

<!--- add all mappings --->
<cfapplication action="update" mappings="#mappings#">
```

Of course you not only can update mappings, you can update all kind of data, <cfappliaction> is supporting all possible settings you can do in the Application.cfc!
