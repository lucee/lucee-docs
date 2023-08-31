```lucee+trycf
<cflogin>
    <cfloginuser name = "test" password = "password" roles = "user,admin,editor">
</cflogin>

<cfdump var="#IsUserInRole(role_name="admin")#" />
```