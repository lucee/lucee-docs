```lucee+trycf
// tag version
<cflogin>
	<cfloginuser name = "test" password = "password" roles = "user,admin,editor">
</cflogin>
<cfdump var="#getAuthUser()#" /> <!--- "mister_user" --->

//script version
login {
     loginuser name = "mister_user" password = "password_too" roles = "user,editor";
}
dump(getAuthUser()); // "mister_user"
```
