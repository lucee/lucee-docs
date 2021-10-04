### Simple Example

```lucee+trycf
<cflogin> 
<cfloginuser
name = "foo"
password ="bar"
roles = "admin"> 
</cflogin> 
<cfoutput>Authorized user: #getAuthUser()# <br></cfoutput>
<cflogout> 
<!--- <cflogout applicationtoken="false">  --->
<cfoutput>Authorized user: #getAuthUser()#</cfoutput>

```
